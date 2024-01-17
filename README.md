# QuickLab - Medical Laboratory Management System

## Table of Contents

- [Introduction](#introduction)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Database Setup](#database-setup)
- [Usage](#usage)
- [Additional Tips](#additional-tips)
- [License](#license)

## Introduction

Welcome to QuickLab, a comprehensive Medical Laboratory Management System designed to address the challenges faced by both patients and medical laboratories in managing and conducting medical analyses. This system not only provides essential management services but also integrates cutting-edge technologies, including Artificial Intelligence (AI) for disease prediction based on analysis results and Optical Character Recognition (OCR) for extracting information from identity cards.

## Getting Started

### Prerequisites

Before you begin, make sure you have the following installed on your system:

- Python
- Virtualenv (optional but recommended)

### Installation

Clone the repository:

```bash
git clone https://github.com/YourUsername/QuickLab.git
cd QuickLab
```
Create a virtual environment:

```bash

python -m venv venv
```
Activate the virtual environment:

On Windows:

```bash

.\venv\Scripts\activate
```
On macOS/Linux:

```bash

source venv/bin/activate
```
Install dependencies:

```bash

pip install -r requirements.txt
```
Run migrations:

```bash

python manage.py migrate
```
Create a superuser (admin):

```bash

python manage.py createsuperuser
```
Run the development server:

```bash

python manage.py runserver
```
## Database Setup
The database script is provided in the "quicklab_database" file. Execute the script in MySQL Workbench. Ensure to change the password, username, and localhost in the code to access the database.

## Usage
Open your web browser and go to http://127.0.0.1:8000/ to access QuickLab.
Access the Django Admin Panel by going to http://127.0.0.1:8000/admin/ and log in with the superuser credentials.
##Sample Result Photos
For your convenience, we have provided sample result photos in the "exemple" (example folder). These images can be referenced to understand the expected format and content of analysis results in QuickLab.

### Accessing Sample Photos
Navigate to the "dossier exemple" folder in the project repository to view and use the sample result photos.

```bash

cd dossier\ exemple
```
Feel free to explore and experiment with the sample photos to better understand the functionalities of QuickLab.

## Additional Tips

- Ensure that you have Python installed on your system.
- It's recommended to use a virtual environment to isolate project dependencies.
- Install required packages using `pip install -r requirements.txt`.
- Make sure to activate the virtual environment before running the server or executing other commands.
- The project uses Django, and you can refer to the [Django documentation](https://docs.djangoproject.com/) for more details.

## License
This project is licensed under the MIT License.

Happy coding!
