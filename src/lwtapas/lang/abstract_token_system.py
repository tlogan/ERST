from __future__ import annotations
from typing import Iterator

from lwtapas.base.abstract_token_system import abstract_token 
import lwtapas.base.abstract_token_system

from lwtapas.base.abstract_token_construct_autogen import abstract_token, Grammar

from pyrsistent import s, m, pmap, v
from typing import Iterator
from pyrsistent.typing import PMap 

from lwtapas.lang import abstract_stream_system as pus 
from lwtapas.lang import abstract_stream_system

from lwtapas.lang import typ_schema_system

def dump(instances : tuple[abstract_token, ...]):
    return lwtapas.base.abstract_token_system.dump(typ_schema_system.node_schema, instances)

def concretize(instances : tuple[abstract_token, ...]):
    return lwtapas.base.abstract_token_system.concretize(typ_schema_system.node_schema, instances)

def concretize_old(instances : tuple[abstract_token, ...]):
    return lwtapas.base.abstract_token_system.concretize_old(typ_schema_system.node_schema, instances)