#!/usr/bin/python3
from pathlib import Path
import numpy as np
from os.path import join
from scipy.spatial.transform import Rotation
import xml.etree.cElementTree as ET
from lxml.etree import Element, tostring, ElementTree, SubElement
import click
import yaml


def addVisual(element: Element, dae_file: str, dae_xyzrpy: list):
    visual = SubElement(element, "visual")
    origin = SubElement(
        visual,
        "origin",
        xyz=f"{dae_xyzrpy[0]} {dae_xyzrpy[1]} {dae_xyzrpy[2]}",
        rpy=f"{dae_xyzrpy[3]} {dae_xyzrpy[4]} {dae_xyzrpy[5]}",
    )
    geometry = SubElement(visual, "geometry")
    mesh = SubElement(
        geometry, "mesh", filename=f"package://ipb_car_hardware/meshes/{dae_file}"
    )


def addCalibration(
    node: Element, from_id: str, to_id: str, T_from_to, dae_file=None, dae_xyzrpy=None
):
    link = SubElement(node, "link", name=from_id)
    if (dae_file is not None) and (dae_xyzrpy is not None):
        addVisual(link, dae_file=dae_file, dae_xyzrpy=dae_xyzrpy)

    joint = SubElement(
        node, "joint", name=f"{from_id}_to_{to_id}", type="fixed")
    child = SubElement(joint, "child", link=from_id)
    parent = SubElement(joint, "parent", link=to_id)
    rpy = Rotation.from_matrix(T_from_to[:3, :3]).as_euler("xyz")
    t = T_from_to[:3, -1]
    origin = SubElement(
        joint, "origin", rpy=f"{rpy[0]} {rpy[1]} {rpy[2]}", xyz=f"{t[0]} {t[1]} {t[2]}"
    )


@click.command()
@click.argument(
    "config_path",
    type=click.Path(exists=True),
    default=join(Path(__file__).parent.parent, "config/"),
)
def main(config_path):
    with open(join(config_path, "calib.yaml"), "r") as calibration_file:
        calib = yaml.safe_load(calibration_file)

    root = Element("robot", name="ipb_car")
    ac_0 = SubElement(root, "link", name=calib["cam_front"]["frame_id"])
    addVisual(
        ac_0,
        dae_file="basler_camera.dae",
        dae_xyzrpy=[0, 0, 0.05, np.pi / 2, 0, 0],
    )

    # cam_front to os_hor
    addCalibration(
        root,
        from_id=calib["os_hpoints"]["frame_id"],
        to_id=calib["cam_front"]["frame_id"],
        T_from_to=np.array(calib["os_hpoints"]["cam_front"]),
        dae_file="ouster.dae",
        dae_xyzrpy=[0, 0, -0.01, 0, 0, 0],
    )
    # cam_front to os_vert
    addCalibration(
        root,
        from_id=calib["os_vpoints"]["frame_id"],
        to_id=calib["cam_front"]["frame_id"],
        T_from_to=np.array(calib["os_vpoints"]["cam_front"]),
        dae_file="ouster.dae",
        dae_xyzrpy=[0, 0, -0.01, 0, 0, 0],
    )

    for i in ["left", "right", "rear"]:
        addCalibration(
            root,
            from_id=calib[f"cam_{i}"]["frame_id"],
            to_id=calib["cam_front"]["frame_id"],
            T_from_to=np.array(calib[f"cam_{i}"]["cam_front"]),
            dae_file="basler_camera.dae",
            dae_xyzrpy=[0, 0, 0.05, np.pi / 2, 0, np.pi / 2],
        )

    # Car model
    offset = [-0.03, 0, -0.015, 0, 0, np.pi/2]
    addCalibration(root,
                   from_id="mount",
                   to_id=calib["os_hpoints"]["frame_id"],
                   T_from_to=np.eye(4),
                   dae_file="car_mount.dae",
                   dae_xyzrpy=offset,
                   )

    addCalibration(root,
                   from_id="car",
                   to_id=calib["os_hpoints"]["frame_id"],
                   T_from_to=np.eye(4),
                   dae_file="passat.dae",
                   dae_xyzrpy=offset,
                   )
    ElementTree(root).write(
        join(config_path, "ipb_car.urdf"), pretty_print=True)


if __name__ == "__main__":
    main()
