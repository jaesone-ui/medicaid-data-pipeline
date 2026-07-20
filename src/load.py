import requests
import os
from google.cloud import storage
from src.extract import extract_data

# function to upload data to GCS (local use only)
def upload_blob(bucket_name, destination_blob_name, year):    
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(destination_blob_name)
    download_url = extract_data(year)

    try:
        with requests.get(download_url, stream=True) as r:
            r.raise_for_status()
            blob.upload_from_file(r.raw, content_type="text/csv")

        print(f"SDUD {year} data uploaded to {destination_blob_name}.")
    except requests.RequestException as e:
        print(f"Error occurred while uploading data for {year}: {e}")
        return None

# used for local testing
if __name__ == "__main__":
    bucket_name = input("Enter the GCS bucket name: ")
    destination_blob_name = input("Enter the destination blob name (e.g., folder/filename.csv): ")
    
    try:
        year = int(input("Enter the year for which you want to load data: "))
        upload_blob(bucket_name, destination_blob_name, year)
    except ValueError:
        print("Invalid input. Please enter a valid year.")
        exit(1)
