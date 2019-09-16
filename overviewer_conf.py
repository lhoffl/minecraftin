import sys

# all the usual config stuff goes here

worlds["world"] = "/home/ubuntu/world"

def signFilter(poi):
	if poi['id'] == 'Sign' or poi['id'] == 'minecraft:oak_sign' or poi['id'] == 'minecraft:spruce_sign' or poi['id'] == 'minecraft:acacia_sign' or poi['id'] == 'minecraft:dark_oak_sign' or poi['id'] == 'minecraft:birch_sign' or poi['id'] == 'minecraft:jungle_sign' or poi['id'] == 'minecraft:sign' or poi['id'] == 'minecraft:oak_wall_sign' or poi['id'] == 'minecraft:spruce_wall_sign' or poi['id'] == 'minecraft:birch_wall_sign' or poi['id'] == 'minecraft:jungle_wall_sign' or poi['id'] == 'minecraft:acacia_wall_sign' or poi['id'] == 'minecraft:dark_oak_wall_sign':
		if poi['Text1'].startswith('[Location]'):
			return "\n".join([poi['Text2'], poi['Text3'], poi['Text4']])

renders['lower-right'] = {
    'world':'world',
    'title':'lower-right',
    'northdirection': "lower-right",
    'rendermode': 'normal',
    'imgformat': 'jpg',
    'imgquality': 60,
    'defaultzoom': 5,
    'markers': [dict(name="Locations", filterFunction=signFilter, checked="true", icon="icons/marker_home.png")],
}

#renders['upper-left'] = {
#    'world':'world',
#    'title':'upper-left',
#   'rendermode': 'normal',
#    'imgquality': 60,
#    'defaultzoom': 5,
#    'markers': [dict(name="Locations", filterFunction=signFilter, checked="true", icon="icons/marker_home.png")],
#}

outputdir = "/home/ubuntu/mcmap"
