$DFL_PATH = Get-Content -Path "paths.txt" -First 1

function GetVideos($path) {
	$extensions = @('.mp4','.avi','.wmv', '.mkv', '.mov', '.mpg', '.mpeg', '.webm', '.m4v', '.3gp', '.3gpp')
	return Get-ChildItem -Path $path | Where-Object {$_.Extension -in $extensions}
}

function HasTrainedMask {
	Set-Location $DFL_PATH\workspace\model
    $files = Get-ChildItem -File
	Set-Location $DFL_PATH
	
    foreach ($file in $files) {
        if ($file.Name -like "*Xseg*") {
            return $true
        }
    }

    return $false
}

function DstExtract() {
	Set-Location $DFL_PATH
	
	Write-Host "STEP (1/3): Video Frame Extraction" -ForegroundColor Yellow 
	echo "jpg" | & .\"3) extract images from video data_dst FULL FPS.bat"
	
	Write-Host "STEP (2/3): Faceset Extraction" -ForegroundColor Yellow 
	echo `n | & .\"5) data_dst faceset extract.bat"
	
	if (HasTrainedMask) {
		Write-Host "STEP (3/3): Applying Trained Mask" -ForegroundColor Yellow 
		echo `n | & .\"5.XSeg) data_dst trained mask - apply.bat"
	}
	else {
		Write-Host "STEP (3/3): [Trained Mask not found] Applying Generic Mask" -ForegroundColor Yellow 
		echo `n | & .\"5.XSeg Generic) data_dst whole_face mask - apply.bat"
	}
}

$index = 0
$dst_videos = GetVideos $DFL_PATH\workspace

while ($dst_videos.count -gt 0)
{
	$index++
	$video = $dst_videos[0]
	Write-Host ("VIDEO ({0:d3}/{1:d3}). {2}" -f $index, ($dst_videos.count + $index - 1), $video.Name) -ForegroundColor Green

	Set-Location $DFL_PATH
	$folder_name   = [System.IO.Path]::GetFileNameWithoutExtension($video)
	$new_file_name = "data_dst{0}" -f [System.IO.Path]::GetExtension($video)
	$video | Rename-Item -NewName $new_file_name
	
	DstExtract $fps

	Set-Location $PSScriptRoot
	python "helpers/1. DST EXTRACT (Clean Up).py" --dfl_path $DFL_PATH --old_video_name $video

	# Results in access denied error so needed to wait 5-seconds
	# Set-Location $DFL_PATH\workspace
	# New-Item -ItemType Directory $folder_name | Out-Null
	# Move-Item $new_file_name $folder_name
	# Start-Sleep -Seconds 5
	# Move-Item "data_dst" $folder_name
	$dst_videos = GetVideos $DFL_PATH\workspace
}

RunDLL32 User32.dll,MessageBeep
Write-Host "Finished! (You may close this window!)" -ForegroundColor Green
pause
