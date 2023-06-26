# deepfacelab path : eg. E:\Tools\DeepFaceLab_NVIDIA_up_to_RTX2080Ti
$df_path = "E:\Tools\DeepFaceLab_NVIDIA_up_to_RTX2080Ti" 

# select files with these extensions 
$extensions = @('.mp4','.avi','.wmv', '.mkv', '.mov', '.mpg', '.mpeg', '.webm', '.m4v', '.3gp', '.3gpp')
$videos = Get-ChildItem -Path $df_path\workspace | Where-Object { $_.Extension -in $extensions }

$index = 0

foreach ($video in $videos) {
	$index++
	Write-Host ("VIDEO ({0:d3}/{1:d3}). {2}" -f $index, $videos.count, $video.Name) -ForegroundColor Green 

	Set-Location $df_path
	
	### PREPARATION
	$extension = [System.IO.Path]::GetExtension($video) # get video extension
	$folder_name = [System.IO.Path]::GetFileNameWithoutExtension($video) # get video name
	$new_file_name  = "data_dst" + $extension # new name: (data_dst.{extension})
	
	### EXTRACTION
	$video | Rename-Item -NewName $new_file_name # rename video file to {new_file_name} for extraction
	
	Write-Host "STEP (1/3): Video Frame Extraction" -ForegroundColor Yellow 
	echo "jpg" | & .\"3) extract images from video data_dst FULL FPS.bat" # extract video frames
	
	Write-Host "STEP (2/3): Faceset Extraction" -ForegroundColor Yellow 
	echo `n | & .\"5) data_dst faceset extract.bat" # excract faces
	
	
	# apply ***TRAINED MASK*** to faces
	# Write-Host "STEP (3/3): Applying Mask" -ForegroundColor Yellow 
	# echo `n | & .\"5.XSeg) data_dst trained mask - apply.bat"
	
	# apply ***GENERIC MASK*** to faces
	Write-Host "STEP (3/3): Applying Mask" -ForegroundColor Yellow 
	echo `n | & .\"5.XSeg Generic) data_dst whole_face mask - apply.bat" 
	
	### PUT EVERYTHING IN TO A FOLDER
	Set-Location $df_path\workspace # go into the workspace directory for file operations
	
	New-Item -ItemType Directory $folder_name | Out-Null # create parent folder with same name as the file
	Move-Item $new_file_name $folder_name -Force # move data_dst video to the parent folder
	
	Start-Sleep -Seconds 5 # wait to prevent "access denied" error (not sure how long so i put 5)
	Move-Item "data_dst" $folder_name -Force # move data_dst folder to the parent folder
}

RunDLL32 User32.dll,MessageBeep
Write-Host "Finished!"
pause