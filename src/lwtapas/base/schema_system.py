from lwtapas.base import rule_system
from lwtapas.base.rule_construct_autogen import ItemHandlers, Rule, Vocab, Terminal, Nonterm 
'''
map from a node id (sequence id) to node (sequence) 
'''
class Schema:
    def __init__(self, 
        singles_schema : list[Rule], 
        choices_schema : dict[str, list[Rule]]
    ):
        self.singles_schema = singles_schema
        self.choices_schema = choices_schema
        self.nodes =  (
            {
                r.name : r 
                for r in self.singles_schema
            } | {
                r.name : r 
                for rs in self.choices_schema.values()
                for r in rs 
            }
        )

        self.full = {
            rule.name : [rule]
            for rule in self.singles_schema 
        } | self.choices_schema

        self.portable = {
            name : [rule_system.to_dictionary(rule) for rule in rules]
            for name, rules in self.full.items()
        }