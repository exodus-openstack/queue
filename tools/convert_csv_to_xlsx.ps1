param(
    [Parameter(Mandatory=$true)] [string]$CsvPath,
    [Parameter(Mandatory=$true)] [string]$XlsxPath
)

$ErrorActionPreference = 'Stop'

# Resolve full paths
$CsvFullPath = (Resolve-Path $CsvPath).Path
$XlsxDir = (Split-Path $XlsxPath -Parent)
if (-not (Test-Path $XlsxDir)) { New-Item -ItemType Directory -Force -Path $XlsxDir | Out-Null }
$XlsxFullPath = (Join-Path $XlsxDir (Split-Path $XlsxPath -Leaf))

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false
try {
    $wb = $excel.Workbooks.Open($CsvFullPath)
    $xlOpenXMLWorkbook = 51
    $wb.SaveAs($XlsxFullPath, $xlOpenXMLWorkbook)
    $wb.Close($false)
}
finally {
    $excel.Quit()
}

Write-Output "Saved: $XlsxFullPath"
