import re
import sys

pattern = r"(jp-RenderedHTMLCommon pre {\s  color:)(.*?);"
filename =  sys.argv[1]
contents = open(filename,"r").read()

def replace(match):
    base = match.group(1)
    return base + " white;"

new_contents = re.sub(pattern, replace, contents)

if contents is new_contents:
    print("Unchanged?")
    sys.exit(1)

with open(filename, "w") as f:
    f.write(new_contents)

print("done patching", filename)