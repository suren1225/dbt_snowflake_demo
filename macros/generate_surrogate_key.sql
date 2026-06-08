{% macro generate_surrogate_key(cols) %}

md5(

    {% for col in cols %}

        coalesce(cast({{ col }} as varchar),'UNKNOWN')

        {% if not loop.last %}
            || '|'
        {% endif %}

    {% endfor %}

)

{% endmacro %}