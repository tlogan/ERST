from __future__ import annotations

from util_system import write_code, project_path
import os 

grammar_path = project_path('src/tapas/slim/Slim.g4')
os.system(f"antlr4 -v 4.13.0 -Dlanguage=Python3 -listener {grammar_path}")