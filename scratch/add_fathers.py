import re

with open('lib/core/data/app_data_store.dart', 'r', encoding='utf-8') as f:
    content = f.read()

def add_father(match):
    dict_str = match.group(0)
    if "'father'" not in dict_str:
        name_match = re.search(r"'name':\s*'([^']+)'", dict_str)
        if name_match:
            name = name_match.group(1)
            last_name = name.split()[-1] if ' ' in name else 'Kumar'
            father_name = f'Mr. {last_name}'
            dict_str = dict_str.replace("'name': '" + name + "',", f"'name': '{name}',\n      'father': '{father_name}',")
    return dict_str

content = re.sub(r'\{[^{}]*?\'name\':\s*\'[^\']+\'[^{}]*?\}', add_father, content)

with open('lib/core/data/app_data_store.dart', 'w', encoding='utf-8') as f:
    f.write(content)
print('Updated app_data_store.dart')
