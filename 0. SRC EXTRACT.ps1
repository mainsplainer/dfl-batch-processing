$DFL_PATH = Get-Content -Path "paths.txt" -First 1

function GetVideos($path) {
	$extensions = @('.mp4','.avi','.wmv', '.mkv', '.mov', '.mpg', '.mpeg', '.webm', '.m4v', '.3gp', '.3gpp')
	return Get-ChildItem -Path $path | Where-Object {$_.Extension -in $extensions}
}

function SrcExtract($fps) {
	Set-Location $DFL_PATH
	
	Write-Host "STEP (1/2): Video Frame Extraction" -ForegroundColor Yellow 
	echo $fps | & .\"2) extract images from video data_src.bat"
	
	Write-Host "STEP (2/2): Faceset Extraction" -ForegroundColor Yellow 
	echo `n | & .\"4) data_src faceset extract.bat"
}

$fps = Read-Host "Enter FPS";
$index = 0
$src_videos = GetVideos $DFL_PATH\workspace

while ($src_videos.count -gt 0)
{
	$index++
	$video = $src_videos[0]
	Write-Host ("VIDEO ({0:d3}/{1:d3}). {2}" -f $index, ($src_videos.count + $index - 1), $video.Name) -ForegroundColor Green
	
	Set-Location $DFL_PATH
	$new_file_name = "data_src{0}" -f [System.IO.Path]::GetExtension($video)
	$video | Rename-Item -NewName $new_file_name
	
	SrcExtract $fps
	python "$PSScriptRoot/helpers/0. SRC EXTRACT (Clean Up).py" --dfl_path $DFL_PATH --index $index --old_video_name $video
	$src_videos = GetVideos $DFL_PATH\workspace
}

RunDLL32 User32.dll,MessageBeep
Write-Host "Finished! (You may close this window!)" -ForegroundColor Green
pause
