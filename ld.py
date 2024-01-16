from barcode import Code39
from barcode.writer import ImageWriter

import barcode
print(dir(barcode))

def generate_code39_barcode(data):
    # Generate a Code39 barcode with the provided data
    code39 = Code39(data, writer=ImageWriter(), add_checksum=False)

    # Save the barcode image to a file
    filename = f"{data}_code39"
    code39.save(filename)

    # Return the filename or do something else with the barcode
    return filename
