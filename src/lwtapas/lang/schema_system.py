'''
map from a node id (sequence id) to node (sequence) 
'''

'''
TODO: construct base class for schema definitions
'''
node_schema = {
    r.name : r 
    for r in singles_schema
} | {
    r.name : r 
    for rs in choices_schema.values()
    for r in rs 
}

schema = {
    rule.name : [rule]
    for rule in singles_schema 
} | choices_schema

# map from a nonterminal to choices of nodes (sequences)
portable_schema = {
    name : [rs.to_dictionary(rule) for rule in rules]
    for name, rules in schema.items()
}