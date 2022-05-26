# CL-intermediary

Intermediaries for CL

## To generate (Run in Repos)
```
java -jar ..\Tools\stitch-0.6.0+local-all.jar updateIntermediary .\jars\old_version.jar .\jars\new_version.jar .\intermediary\intermediary\old_version.tiny .\intermediary\intermediary\new_version.tiny .\intermediary\matches\old_version-new_version.match -p CL.+ -f CL.+ -m func_.+`|^[a-z]{1,4}$
```
