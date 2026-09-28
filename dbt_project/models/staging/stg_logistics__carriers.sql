select
    carrier_id::varchar as carrier_id,
    carrier_name::varchar as carrier_name,
    service_level::varchar as service_level,
    _loaded_at::timestamp_ntz as _loaded_at
from {{ source('logistics', 'carriers') }}
