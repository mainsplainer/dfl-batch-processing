import os
import shutil
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--dfl_path")
parser.add_argument("--index")
parser.add_argument("--old_video_name")

args = parser.parse_args()
processed_videos = "processed_srcs"
aligned_faces    = "aligned"

video_name = ".".join(args.old_video_name.split(".")[:-1])
video_ext  = args.old_video_name.split(".")[-1]

os.chdir(f"{args.dfl_path}/workspace")
os.makedirs(aligned_faces   , exist_ok=True)
os.makedirs(processed_videos, exist_ok=True)

os.chdir(f"{args.dfl_path}/workspace/data_src/aligned")

for file in os.listdir():
    os.rename(file, f"{args.index}_{video_name}_{file}")

os.chdir(f"{args.dfl_path}/workspace/")
shutil.move(f"data_src.{video_ext}", f"processed_videos/{args.old_video_name}")

for aligned_face in os.listdir("data_src/aligned/"):
    shutil.move(f"data_src/aligned/{aligned_face}", aligned_faces)

shutil.rmtree("data_src")