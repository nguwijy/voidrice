from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select


# You need both chromedriver and chrome for this to work
# For chrome, you can download easily from software center
# For chromedriver, maybe this is something to be checked with IT, but the links are below:
# https://googlechromelabs.github.io/chrome-for-testing/
# https://storage.googleapis.com/chrome-for-testing-public/125.0.6422.60/linux64/chromedriver-linux64.zip
# https://storage.googleapis.com/chrome-for-testing-public/125.0.6422.60/win64/chromedriver-win64.zip
CHROME_DRIVER_PATH = '/home/nguwijy/Downloads/chromedriver-linux64/chromedriver'
CHROME_PATH        = '/usr/bin/google-chrome-stable'
DOWNLOAD_PATH      = '/home/nguwijy/'
TARGET_URL         = 'https://eservices.mas.gov.sg/statistics/fdanet/BondPricesAndYields.aspx'

# parse the relevant paths to the driver
options = webdriver.ChromeOptions()
options.binary_location = CHROME_PATH
prefs = {'download.default_directory': DOWNLOAD_PATH, 'directory_upgrade': True}
options.add_experimental_option('prefs', prefs)
service = webdriver.ChromeService(executable_path=CHROME_DRIVER_PATH)
driver = webdriver.Chrome(service=service, options=options)

# access the url
driver.get(TARGET_URL)

# change the dropdown values
# others dropdowns include
# OptionSelect, ContentPlaceHolder1_StartMonthDropDownList, ContentPlaceHolder1_EndYearDropDownList
# ContentPlaceHolder1_EndMonthDropDownList, ContentPlaceHolder1_FrequencyDropDownList
select = Select(driver.find_elements(value='ContentPlaceHolder1_StartYearDropDownList')[0])
select.select_by_visible_text('2021')

# Select all and download!
driver.find_elements(By.XPATH, "//*[contains(text(), 'Select All')]")[0].click()
driver.find_element(value='ContentPlaceHolder1_Button2').click()
driver.close()
