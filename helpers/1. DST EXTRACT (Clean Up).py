import os
import shutil
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--dfl_path")
parser.add_argument("--old_video_name")

args = parser.parse_args()

folder_name = ".".join(args.old_video_name.split(".")[:-1])
video_ext   = args.old_video_name.split(".")[-1]

os.chdir(f"{args.dfl_path}/workspace")
os.makedirs(folder_name, exist_ok=True)

shutil.move(f"data_dst.{video_ext}", folder_name)
shutil.move(f"data_dst"            , folder_name)