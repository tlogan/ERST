from __future__ import annotations

from core.util_system import write_code
from core import \
    construction_system, rich_token_plan, \
    line_format_plan, meta_plan 

write_code('core', "meta",
    construction_system.generate(meta_plan.construction)
)

write_code('core', "rich_token", 
    construction_system.generate(rich_token_plan.construction)
)

write_code('core', "line_format", 
    construction_system.generate(line_format_plan.construction)
)