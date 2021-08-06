import os
from pathlib import Path

path = input("Custom Path\n(leaving blank will use this folder as the location\nEnter Path:")

if path == "":
    path = Path(__file__).parent.absolute()


def create_folder(path,foldername):
    try:
        os.mkdir(os.path.join(path,foldername))
    except OSError as error:
        print(error)

def writefile(path,folder,filename):
    f = open(os.path.join(os.path.join(path,folder),filename),"w")
    print(f"{filename} created")

folders = ["client","server","cfg","html"]
html_files = ["index.html","styles.css","script.js"]


for f in folders:
    create_folder(path,f)

writefile(path,"client","cl_main.lua")
writefile(path,"server","sv_main.lua")
writefile(path,"cfg","cfg_main.lua")

for file in html_files:
    f = open(os.path.join(os.path.join(path,"html"),file),"w")
    print(f"{file} created")
html = open(os.path.join(os.path.join(path,"html"),"index.html"),"w")
html.write("""<!DOCTYPE html>\n<html lang="en">\n<head>\n    <link rel="stylesheet" href="styles.css">\n    <title>uh oh swag time</title>\n</head>\n<body>\n    \n</body>\n<script src="script.js"></script>\n</html>""")
html.close()
print("index.html created")


file = open(os.path.join(path,"fxmanifest.lua"),"w")
file.write("""fx_version 'cerulean'\ngame 'gta5'\nclient_scripts{\n    'client/cl_*.lua'\n}\nserver_scripts{\n    'server/sv_*.lua'\n}\nshared_scripts{\n    'cfg/cfg_*.lua'\n}\nui_page('html/index.html')\nfiles({\n	"html/script.js",\n	"html/styles.css",\n	"html/index.html",\n})""")
file.close()
print("fxmanifest.lua created")
