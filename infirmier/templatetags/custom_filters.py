from django import template
from datetime import date

register = template.Library()

@register.filter
def calculate_age(birth_date):
    today = date.today()
    age = today.year - birth_date.year
    if today.month < birth_date.month or (today.month == birth_date.month and today.day < birth_date.day):
        age -= 1
    return age


@register.filter
def calculate_marge(units):
    
    length = len(units) 
    if length<5:
        length = length * 20
    elif  5 <= length < 10:
        length = length * 10
    elif  10 <= length < 12:
        length = length * 8
    elif  12 <= length < 15:
        length = length * 9
    else:
        length = length * 8
    return length

@register.filter
def get_value(dictionary, key):
    return dictionary.get(str(key), '')




@register.filter
def dict_get(dictionary, key):
    return dictionary.get(key)

@register.filter
def split_string(value, delimiter):
    return value.split(delimiter)