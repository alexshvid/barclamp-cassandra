@rem
@rem Copyright 2012, Mirantis, Inc
@rem
@rem Licensed under the Apache License, Version 2.0 (the "License");
@rem you may not use this file except in compliance with the License.
@rem You may obtain a copy of the License at
@rem
@rem  http://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an "AS IS" BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.
@rem

@set PROJ_DIR=%~dp0
@cd %PROJ_DIR%

@set BARCLAMP=cassandra

@call haml --check crowbar_framework\app\views\barclamp\%BARCLAMP%\*.haml
@call kwalify -lf chef\data_bags\crowbar\bc-template-%BARCLAMP%.schema chef\data_bags\crowbar\bc-template-%BARCLAMP%.json
pause
