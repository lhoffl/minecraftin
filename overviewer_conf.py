import sys

# all the usual config stuff goes here

worlds["world"] = "/home/ubuntu/world"

#renders["smooth_lighting"] = {
 #   "title" : "minecraftin",
  #  "world" : "world",
   # "manualpois" : mymarkers,                         # IMPORTANT! Variable name from manualmarkers.py
    # and here goes the list of the filters, etc.
#}

def signFilter(poi):
	if poi['id'] == 'Sign' or poi['id'] == 'minecraft:oak_sign' or poi['id'] == 'minecraft:spruce_sign' or poi['id'] == 'minecraft:acacia_sign' or poi['id'] == 'minecraft:dark_oak_sign' or poi['id'] == 'minecraft:birch_sign' or poi['id'] == 'minecraft:jungle_sign' or poi['id'] == 'minecraft:sign' or poi['id'] == 'minecraft:oak_wall_sign' or poi['id'] == 'minecraft:spruce_wall_sign' or poi['id'] == 'minecraft:birch_wall_sign' or poi['id'] == 'minecraft:jungle_wall_sign' or poi['id'] == 'minecraft:acacia_wall_sign' or poi['id'] == 'minecraft:dark_oak_wall_sign':
		if poi['Text1'].startswith('[Location]'):
			return "\n".join([poi['Text2'], poi['Text3'], poi['Text4']])

renders['lower-right'] = {
    'world':'world',
    'title':'lower-right',
    'northdirection': "lower-right",
    'markers': [dict(name="Locations", filterFunction=signFilter, checked="true", icon="icons/marker_home.png")],
}

renders['upper-left'] = {
    'world':'world',
    'title':'upper-left',
    'markers': [dict(name="Locations", filterFunction=signFilter, checked="true", icon="icons/marker_home.png")],
}

outputdir = "/home/ubuntu/mcmap"
