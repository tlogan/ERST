from core import rule_system
from core.rule_system import Rule
'''
map from a node id (sequence id) to node (sequence) 
'''
class Schema:
    def __init__(self, 
        singles : list[Rule], 
        choices : dict[str, list[Rule]]
    ):
        self.singles = singles
        self.choices = choices
        self.nodes =  (
            {
                r.name : r 
                for r in self.singles
            } | {
                r.name : r 
                for rs in self.choices.values()
                for r in rs 
            }
        )

        self.full = {
            rule.name : [rule]
            for rule in self.singles 
        } | self.choices

        self.portable = {
            name : [rule_system.to_dictionary(rule) for rule in rules]
            for name, rules in self.full.items()
        }