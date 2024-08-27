from setuptools import setup, find_packages

setup(
    name="betterself",
    version="0.1.0",
    description="",
    author="Your Name",
    author_email="you@example.com",
    python_requires=">=3.8",
    install_requires=[
        "django>=5.0",
        "djangorestframework>=3.15",
    ],
    packages=["betterself", "betterself_server"]
)
