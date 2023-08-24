from setuptools import find_packages, setup

package_name = "ipb_car_hardware"

setup(
    name=package_name,
    version="0.0.1",
    packages=find_packages(exclude=["test"]),
    data_files=[
        ("share/" + package_name, ["package.xml"]),
    ],
    install_requires=["setuptools"],
    zip_safe=True,
    maintainer="ivizzo",
    maintainer_email="ivizzo@uni-bonn.de",
    description="Maintaining the hardware models as well as the URDF models from the calibration.",
    license="MI`t",
    entry_points={
        "console_scripts": ["create_urdf = ipb_car_hardware.create_urdf:main"],
    },
)
