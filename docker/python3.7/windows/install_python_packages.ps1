$ErrorActionPreference = "Stop"

function New-TemporaryDirectory {
  $parent = [System.IO.Path]::GetTempPath()
  [string] $name = [System.Guid]::NewGuid()
  New-Item -ItemType Directory -Path (Join-Path $parent $name)
}

$workDir = New-TemporaryDirectory

cd $workDir

# Install numpy, scipy, and shapely from Python Extensions with Intel MKL
Invoke-WebRequest `
  -Uri 'https://download.lfd.uci.edu/pythonlibs/q4hpdf1k/numpy-1.18.1+mkl-cp37-cp37m-win_amd64.whl' `
  -OutFile 'numpy-1.18.1+mkl-cp37-cp37m-win_amd64.whl'
python -m pip install '.\numpy-1.18.1+mkl-cp37-cp37m-win_amd64.whl'

Invoke-WebRequest `
  -Uri 'https://download.lfd.uci.edu/pythonlibs/q4hpdf1k/scipy-1.4.1-cp37-cp37m-win_amd64.whl' `
  -OutFile 'scipy-1.4.1-cp37-cp37m-win_amd64.whl'
python -m pip install '.\scipy-1.4.1-cp37-cp37m-win_amd64.whl'

Invoke-WebRequest `
  -Uri 'https://download.lfd.uci.edu/pythonlibs/q4hpdf1k/Shapely-1.7.0-cp37-cp37m-win_amd64.whl' `
  -OutFile 'Shapely-1.7.0-cp37-cp37m-win_amd64.whl'
python -m pip install '.\Shapely-1.7.0-cp37-cp37m-win_amd64.whl'

# Install other packages.
python -m pip install PyQt5==5.14.1
python -m pip install appdirs==1.4.3
python -m pip install certifi==2019.11.28
python -m pip install cffi==1.13.2
python -m pip install chardet==3.0.4
python -m pip install cryptography==2.8
python -m pip install cx-Freeze==6.1
python -m pip install decorator==4.4.1
python -m pip install idna==2.8
python -m pip install lxml==4.5.0
python -m pip install netifaces==0.10.9
python -m pip install networkx==2.4
python -m pip install numpy-stl==2.10.1
python -m pip install packaging==20.1
python -m pip install pycollada==0.7.1
python -m pip install pycparser==2.19
python -m pip install pyparsing==2.4.6
python -m pip install pyserial==3.4
python -m pip install python-dateutil==2.8.1
python -m pip install python-utils==2.3.0
python -m pip install requests==2.22.0
python -m pip install sentry-sdk==0.14.1
python -m pip install six==1.14.0
python -m pip install trimesh==3.2.33
python -m pip install typing==3.7.4.1
python -m pip install twisted==19.10.0
python -m pip install urllib3==1.25.8
python -m pip install PyYAML==5.3
python -m pip install zeroconf==0.24.4

python -m pip install comtypes==1.1.7

# Clean up
cd ~
Remove-Item -Recurse -Force $workDir
