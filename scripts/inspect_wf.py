import json

with open('workflows/commercial_product_video/workflow.json', 'r', encoding='utf-8') as f:
    wf = json.load(f)

print(f"Nodes count: {len(wf.get('nodes', []))}")
print(f"Links count: {len(wf.get('links', []))}")
print(f"Groups count: {len(wf.get('groups', []))}")
print("Extra keys:", list(wf.get('extra', {}).keys()))

import sys
sys.stdout.reconfigure(encoding='utf-8')
print("\n=== FIRST 10 NODES ===")
for node in wf.get('nodes', [])[:10]:
    nid = node['id']
    ntype = node.get('type')
    title = node.get('title')
    wv = node.get('widgets_values')
    print(f"Node {nid:2d} | {str(ntype):25s} | {str(title):35s} | widgets_values: {wv}")


print("\n=== SUBGRAPHS ===")
subgraphs = wf.get('definitions', {}).get('subgraphs', {})
if isinstance(subgraphs, list):
    for sg in subgraphs:
        print(f"Subgraph ID: {sg.get('id')} | Name: {sg.get('name')}")
        print(f"  Inputs: {sg.get('inputs')}")
        print(f"  Outputs: {sg.get('outputs')}")
else:
    for sg_id, sg_data in subgraphs.items():
        print(f"Subgraph ID: {sg_id} | Name: {sg_data.get('name')}")
        print(f"  Inputs: {sg_data.get('inputs')}")
        print(f"  Outputs: {sg_data.get('outputs')}")


print("\n=== NODES WIDGETS & PROPERTIES ===")
for node in wf.get('nodes', []):
    nid = node['id']
    ntype = node.get('type')
    title = node.get('title')
    wv = node.get('widgets_values')
    print(f"Node {nid:2d} | {str(ntype):25s} | {str(title):35s} | widgets_values: {wv}")


