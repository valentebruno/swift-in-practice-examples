"""Swift in Practice, Edition 44: the fixture assembly.

Builds a two-part assembly (Housing, Bracket) whose leaf meshes carry the generic
names an export tool would choose, exports it as USDZ, and renders two figures:
what a person sees (two parts) and what a hit test returns (eight leaf meshes).

Run headless:
    blender -b --factory-startup --python make_assembly.py -- OUTPUT_DIR
"""
import math
import sys
from pathlib import Path

import bpy
from mathutils import Vector

OUT = Path(sys.argv[sys.argv.index("--") + 1] if "--" in sys.argv else ".").resolve()
OUT.mkdir(parents=True, exist_ok=True)

# ---------------------------------------------------------------- scene reset
bpy.ops.wm.read_factory_settings(use_empty=True)
scene = bpy.context.scene
scene.unit_settings.system = "METRIC"
scene.unit_settings.scale_length = 1.0


def material(name, color, metallic=0.0, roughness=0.45):
    mat = bpy.data.materials.new(name)
    mat.use_nodes = True
    bsdf = mat.node_tree.nodes["Principled BSDF"]
    bsdf.inputs["Base Color"].default_value = (*color, 1.0)
    bsdf.inputs["Metallic"].default_value = metallic
    bsdf.inputs["Roughness"].default_value = roughness
    return mat


def srgb(hex_color):
    value = int(hex_color.lstrip("#"), 16)
    channels = [(value >> shift & 0xFF) / 255 for shift in (16, 8, 0)]
    return tuple(c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4 for c in channels)


def bevel(obj, width=0.0015):
    modifier = obj.modifiers.new("Bevel", "BEVEL")
    modifier.width = width
    modifier.segments = 3
    modifier.limit_method = "ANGLE"


def box(name, size, location, parent, mat):
    bpy.ops.mesh.primitive_cube_add(size=1, location=location)
    obj = bpy.context.active_object
    obj.name = obj.data.name = name
    obj.scale = size
    bpy.ops.object.transform_apply(scale=True)
    bevel(obj)
    obj.data.materials.append(mat)
    obj.parent = parent
    return obj


def cylinder(name, radius, depth, location, parent, mat, axis="X"):
    rotation = {"X": (0, math.pi / 2, 0), "Y": (math.pi / 2, 0, 0), "Z": (0, 0, 0)}[axis]
    bpy.ops.mesh.primitive_cylinder_add(vertices=48, radius=radius, depth=depth, location=location, rotation=rotation)
    obj = bpy.context.active_object
    obj.name = obj.data.name = name
    bpy.ops.object.transform_apply(rotation=True)
    bpy.ops.object.shade_smooth()
    bevel(obj, 0.0008)
    obj.data.materials.append(mat)
    obj.parent = parent
    return obj


def part_root(name):
    root = bpy.data.objects.new(name, None)          # an Xform in USD: the part root
    root.empty_display_type = "PLAIN_AXES"
    root.empty_display_size = 0.02
    scene.collection.objects.link(root)
    return root


# ---------------------------------------------------------------- the assembly
housing_mat = material("HousingMaterial", srgb("#5b6b82"), metallic=0.55, roughness=0.38)
lid_mat = material("LidMaterial", srgb("#46546a"), metallic=0.55, roughness=0.42)
steel_mat = material("SteelMaterial", srgb("#c9ced6"), metallic=1.0, roughness=0.25)
bracket_mat = material("BracketMaterial", srgb("#e8a33d"), metallic=0.2, roughness=0.5)

housing = part_root("Housing")
bracket = part_root("Bracket")

# Leaf names are what an export tool produces, deliberately meaningless.
leaves = {
    housing: [
        box("Cube.001", (0.120, 0.080, 0.050), (0.0, 0.0, 0.025), housing, housing_mat),
        box("Cube.002", (0.124, 0.084, 0.008), (0.0, 0.0, 0.054), housing, lid_mat),
        cylinder("Cylinder.003", 0.016, 0.014, (0.067, 0.0, 0.028), housing, housing_mat),
        cylinder("Cylinder.004", 0.0055, 0.045, (0.085, 0.0, 0.028), housing, steel_mat),
    ],
    bracket: [
        box("Cube.005", (0.006, 0.070, 0.060), (-0.063, 0.0, 0.030), bracket, bracket_mat),
        box("Cube.006", (0.040, 0.070, 0.006), (-0.083, 0.0, 0.003), bracket, bracket_mat),
        cylinder("Cylinder.007", 0.0042, 0.016, (-0.062, 0.022, 0.036), bracket, steel_mat),
        cylinder("Cylinder.008", 0.0042, 0.016, (-0.062, -0.022, 0.036), bracket, steel_mat),
    ],
}
part_objects = [housing, bracket] + [leaf for group in leaves.values() for leaf in group]

# ---------------------------------------------------------------- USDZ export
bpy.ops.object.select_all(action="DESELECT")
for obj in part_objects:
    obj.select_set(True)
usd_options = dict(filepath=str(OUT / "assembly.usdz"), selected_objects_only=True,
                   export_materials=True, root_prim_path="/Assembly")
try:
    bpy.ops.wm.usd_export(**usd_options, convert_orientation=True, export_global_forward_selection="NEGATIVE_Z",
                          export_global_up_selection="Y")
except TypeError:
    bpy.ops.wm.usd_export(**usd_options)
bpy.ops.wm.save_as_mainfile(filepath=str(OUT / "assembly.blend"))

# ---------------------------------------------------------------- render setup
import itertools
from bpy_extras.object_utils import world_to_camera_view

scene.render.engine = "BLENDER_EEVEE"
scene.render.resolution_x, scene.render.resolution_y = 1600, 900
scene.view_settings.view_transform = "AgX"
scene.view_settings.look = "AgX - Medium High Contrast"
world = bpy.data.worlds.new("World")
scene.world = world
world.use_nodes = True
world.node_tree.nodes["Background"].inputs["Color"].default_value = (*srgb("#141c33"), 1)
world.node_tree.nodes["Background"].inputs["Strength"].default_value = 0.25


def area_light(location, energy, size, aim):
    bpy.ops.object.light_add(type="AREA", location=location)
    light = bpy.context.active_object
    light.data.energy, light.data.size = energy, size
    aim_at = light.constraints.new("TRACK_TO")
    aim_at.target, aim_at.track_axis, aim_at.up_axis = aim, "TRACK_NEGATIVE_Z", "UP_Y"
    return light


target = bpy.data.objects.new("Target", None)
scene.collection.objects.link(target)
target.location = (0.0, 0.0, 0.026)
area_light((0.20, -0.28, 0.32), 9, 0.30, target)      # key
area_light((-0.32, -0.12, 0.20), 3, 0.50, target)     # fill
area_light((0.05, 0.30, 0.22), 6, 0.25, target)       # rim

bpy.ops.mesh.primitive_plane_add(size=6, location=(0, 0, 0))
floor = bpy.context.active_object
floor.data.materials.append(material("Floor", srgb("#151d35"), roughness=0.65))

bpy.ops.object.camera_add(location=(-0.115, -0.27, 0.175))
camera = bpy.context.active_object
camera.data.lens = 50
track = camera.constraints.new("TRACK_TO")
track.target, track.track_axis, track.up_axis = target, "TRACK_NEGATIVE_Z", "UP_Y"
scene.camera = camera


def render(name):
    scene.render.filepath = str(OUT / name)
    bpy.ops.render.render(write_still=True)


# Figure 1: what the person sees, two parts.
render("assembly.png")

# Figure 2: what the hit test returns, eight leaf meshes, pulled apart and labelled.
palette = ["#76b7b2", "#4e79a7", "#b07aa1", "#e15759", "#f28e2b", "#edc948", "#59a14f", "#ff9da7"]
housing.location.x += 0.012
bracket.location.x -= 0.022
bracket.location.y -= 0.03
target.location = (0.0, -0.015, 0.026)
camera.location = (0.085, -0.36, 0.215)
camera.data.lens = 38
for index, leaf in enumerate(leaf for group in leaves.values() for leaf in group):
    leaf.data.materials[0] = material(f"Leaf{index}", srgb(palette[index]), roughness=0.55)
bpy.context.view_layer.update()
camera.matrix_world  # refresh after moving the camera
bpy.context.view_layer.update()

white = material("LabelText", (1, 1, 1))
white.node_tree.nodes["Principled BSDF"].inputs["Emission Color"].default_value = (1, 1, 1, 1)
white.node_tree.nodes["Principled BSDF"].inputs["Emission Strength"].default_value = 3.0
pill = material("LabelPill", srgb("#0b1022"), roughness=1.0)

cam = camera.matrix_world.copy()
frame = [Vector(c) for c in camera.data.view_frame(scene=scene)]   # camera space, z < 0
DEPTH = 0.12                                                        # in front of the model


def screen_to_world(u, v):
    """(u, v) in 0…1 frame space → a point DEPTH metres in front of the camera."""
    scale = DEPTH / -frame[0].z
    left, right = min(c.x for c in frame) * scale, max(c.x for c in frame) * scale
    bottom, top = min(c.y for c in frame) * scale, max(c.y for c in frame) * scale
    return cam @ Vector((left + (right - left) * u, bottom + (top - bottom) * v, -DEPTH))


frame_height = (max(c.y for c in frame) - min(c.y for c in frame)) * DEPTH / -frame[0].z


def leader(start, end, radius):
    direction = end - start
    bpy.ops.mesh.primitive_cylinder_add(vertices=12, radius=radius, depth=direction.length,
                                        location=(start + end) / 2)
    line = bpy.context.active_object
    line.rotation_mode = "QUATERNION"
    line.rotation_quaternion = Vector((0, 0, 1)).rotation_difference(direction.normalized())
    line.data.materials.append(white)


def anchor(leaf):
    """A point on the leaf that the camera can actually see."""
    depsgraph = bpy.context.evaluated_depsgraph_get()
    corners = [leaf.matrix_world @ Vector(c) for c in leaf.bound_box]
    center = sum(corners, Vector()) / 8
    eye = camera.matrix_world.translation
    candidates = [center] + [center.lerp(c, t) for t in (0.3, 0.6) for c in corners]
    for point in candidates:
        hit, location, _, _, obj, _ = scene.ray_cast(depsgraph, eye, (point - eye).normalized())
        if hit and obj.name == leaf.name:
            return location
    return center


def dot(location, radius):
    bpy.ops.mesh.primitive_uv_sphere_add(radius=radius, location=location, segments=16, ring_count=8)
    bpy.context.active_object.data.materials.append(white)


columns = {bracket: (0.05, "LEFT"), housing: (0.83, "LEFT")}
for root, group in leaves.items():
    u, align = columns[root]
    ends = {leaf.name: anchor(leaf) for leaf in group}
    screen = {name: world_to_camera_view(scene, camera, point) for name, point in ends.items()}
    gap = 0.105
    middle = sum(p.y for p in screen.values()) / len(screen)
    middle = min(0.92 - gap * (len(group) - 1) / 2, max(0.08 + gap * (len(group) - 1) / 2, middle))
    slots = [middle + gap * ((len(group) - 1) / 2 - k) for k in range(len(group))]
    edge = u + 0.14 if u < 0.5 else u - 0.01

    def crossings(order):
        segments = [((edge, v), (screen[leaf.name].x, screen[leaf.name].y)) for v, leaf in zip(slots, order)]
        def ccw(a, b, c):
            return (c[1] - a[1]) * (b[0] - a[0]) > (b[1] - a[1]) * (c[0] - a[0])
        count = 0
        for i in range(len(segments)):
            for j in range(i + 1, len(segments)):
                (a, b), (c, d) = segments[i], segments[j]
                count += ccw(a, c, d) != ccw(b, c, d) and ccw(a, b, c) != ccw(a, b, d)
        length = sum(((a[0] - b[0]) ** 2 + (a[1] - b[1]) ** 2) ** 0.5 for a, b in segments)
        return count, length

    ordered = min(itertools.permutations(group), key=crossings)
    for v, leaf in zip(slots, ordered):
        position = screen_to_world(u, v)
        bpy.ops.object.text_add(location=position)
        text = bpy.context.active_object
        text.data.body = leaf.name
        text.data.size = frame_height * 0.042
        text.data.align_x, text.data.align_y = "LEFT", "CENTER"
        text.data.materials.append(white)
        text.matrix_world = cam.to_3x3().to_4x4()
        text.location = position
        bpy.context.view_layer.update()
        width = text.dimensions.x
        pad = frame_height * 0.016
        bpy.ops.mesh.primitive_plane_add(size=1)
        back = bpy.context.active_object
        back.matrix_world = cam.to_3x3().to_4x4()
        right = cam.to_3x3() @ Vector((1, 0, 0))
        toward_camera = cam.to_3x3() @ Vector((0, 0, 1))
        back.location = position + right * (width / 2) - toward_camera * 0.0005
        back.scale = (width + 2 * pad, frame_height * 0.042 + 1.4 * pad, 1)
        back.data.materials.append(pill)
        start = position + right * (width + pad) if u < 0.5 else position - right * pad
        end = ends[leaf.name]
        leader(start, end, frame_height * 0.003)
        dot(end, frame_height * 0.011)
render("leaf-meshes.png")
print("WROTE", sorted(p.name for p in OUT.iterdir()))
