import requests
import json

def extract_data(year):
    url = "https://data.medicaid.gov/api/1/search"
    payload = {"fulltext": f"State Drug Utilization Data {year}"}

    try:
        r = requests.get(url, params=payload)
        r.raise_for_status()
    except requests.RequestException as e:
        print(f"Error fetching data for {year}: {e}")
        return None
    
    data = r.json()
    if int(data.get("total")) == 1:
        results = data.get("results", {})
        results_values = next(iter(results.values()), {})
        distribution = results_values.get("distribution", [])

        if distribution:
            download_url = distribution[0].get("downloadURL")
            print(f"Found SDUD data for {year}: {download_url}")
            return download_url

    print(f"No SDUD data found for {year}.")