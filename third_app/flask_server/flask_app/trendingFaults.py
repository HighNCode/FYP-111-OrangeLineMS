# from datetime import datetime, timedelta
# from supabase import create_client, Client
# import matplotlib.pyplot as plt

# url = "https://typmqqidaijuobjosrpi.supabase.co"
# key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR5cG1xcWlkYWlqdW9iam9zcnBpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM0MzkzODAsImV4cCI6MjAwOTAxNTM4MH0.Ihde633Yj9FFaQ7hKLooxDxaFEno4fK8YxSb3gy8S4c"
# supabase: Client = create_client(url, key)

# def fetch_all_rows(table_name, page_size=1000):
#     offset = 0
#     all_rows = []
    
#     while True:
#         response = supabase.table(table_name).select("*").range(offset, offset + page_size - 1).execute()
#         data = response.data
#         if not data:
#             break
#         all_rows.extend(data)
#         if len(data) < page_size:
#             break
#         offset += page_size
    
#     return all_rows

# table_name = "FaultData"
# rows = fetch_all_rows(table_name)

# # Date calculations
# current_date = datetime.now().date()
# three_days_ago = current_date - timedelta(days=3)
# ten_days_ago = current_date - timedelta(days=10)

# equipment_faults = {}
# for row in rows:
#     equipment = row["Equipment"]
#     fault_date = datetime.strptime(row["OccurrenceDate"], "%Y-%m-%d").date()

#     if equipment not in equipment_faults:
#         equipment_faults[equipment] = {
#             "count": 0, 
#             "recent_fault": False, 
#             "faults_last_3_days": 0,  # Counter for faults in the last 3 days
#             "day_4_to_10": False
#         }

#     equipment_faults[equipment]["count"] += 1

#     # Check if fault occurred in the last 3 days
#     if three_days_ago < fault_date <= current_date:
#         equipment_faults[equipment]["faults_last_3_days"] += 1  # Increment counter
    
#     # Check if fault occurred in the days 4 to 10 ago
#     if ten_days_ago < fault_date <= three_days_ago:
#         equipment_faults[equipment]["day_4_to_10"] = True

# for equipment in equipment_faults:
#     conditions_met = (
#         equipment_faults[equipment]["faults_last_3_days"] > 1 or
#         (equipment_faults[equipment]["faults_last_3_days"] > 0 and equipment_faults[equipment]["day_4_to_10"])
#     )
#     if conditions_met:
#         equipment_faults[equipment]["recent_fault"] = True

# for equipment in equipment_faults:
#     del equipment_faults[equipment]["faults_last_3_days"]
#     del equipment_faults[equipment]["day_4_to_10"]

# equipment_faults = {key: val for key, val in equipment_faults.items() if key is not None}

# sorted_equipment = sorted(equipment_faults.items(), key=lambda x: x[1]["count"], reverse=True)[1:9]
# equipment_names = [item[0] for item in sorted_equipment]
# faults_counts = [item[1]["count"] for item in sorted_equipment]
# colors = ['red' if item[1]["recent_fault"] else 'skyblue' for item in sorted_equipment]

# plt.figure(figsize=(12, 8))
# bars = plt.bar(equipment_names, faults_counts, color=, alpha=0.75, edgecolor='black')
# plt.title("Trending Faults", fontsize=16, fontweight='bold')
# plt.xlabel("Equipment", fontsize=14)
# plt.ylabel("Faults Count", fontsize=14)
# plt.xticks([])
# plt.yticks(fontsize=12)
# plt.grid(color='gray', linestyle='--', linewidth=0.5, axis='y', alpha=0.7)

# fixed_vertical_height = 7

# for bar, label in zip(bars, equipment_names):
#     yval = bar.get_height()
#     plt.text(bar.get_x() + bar.get_width()/2, yval, int(yval), ha='center', va='bottom', fontsize=10, fontweight='bold')
#     plt.text(bar.get_x() + bar.get_width()/2, fixed_vertical_height, label, ha='center', va='bottom', fontsize=8, color='black', rotation=90)

# plt.tight_layout()
# plt.show()

from datetime import datetime, timedelta
from supabase import create_client, Client
import matplotlib.pyplot as plt

def trendingFault():

    url = "https://typmqqidaijuobjosrpi.supabase.co"
    key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR5cG1xcWlkYWlqdW9iam9zcnBpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM0MzkzODAsImV4cCI6MjAwOTAxNTM4MH0.Ihde633Yj9FFaQ7hKLooxDxaFEno4fK8YxSb3gy8S4c"
    supabase: Client = create_client(url, key)

    def fetch_all_rows(table_name, page_size=1000):
        offset = 0
        all_rows = []
        
        while True:
            response = supabase.table(table_name).select("*").range(offset, offset + page_size - 1).execute()
            data = response.data
            if not data:
                break
            all_rows.extend(data)
            if len(data) < page_size:
                break
            offset += page_size
        
        return all_rows

    def filter_faults_by_date(rows, start_date, end_date):
        filtered_faults = []
        for row in rows:
            fault_date = datetime.strptime(row["OccurrenceDate"], "%Y-%m-%d").date()
            if start_date <= fault_date <= end_date:
                filtered_faults.append(row)
        return filtered_faults

    table_name = "FaultData"
    rows = fetch_all_rows(table_name)

    # Define start date and end date
    start_date = datetime(2020, 3, 1).date()  # Replace with your start date
    end_date = datetime(2024, 3, 15).date()   # Replace with your end date

    # Filter faults based on start date and end date
    filtered_faults = filter_faults_by_date(rows, start_date, end_date)

    equipment_faults = {}
    for row in filtered_faults:
        equipment = row["Equipment"]
        
        if equipment == "Others" or equipment == None:
            continue
        
        if equipment not in equipment_faults:
            equipment_faults[equipment] = 0
        
        equipment_faults[equipment] += 1

    # Plotting
    sorted_equipment = sorted(equipment_faults.items(), key=lambda x: x[1], reverse=True)[:10]
    equipment_names = [item[0] for item in sorted_equipment]
    faults_counts = [item[1] for item in sorted_equipment]

    plt.figure(figsize=(12, 8))
    bars = plt.bar(equipment_names, faults_counts, color='skyblue', alpha=0.75, edgecolor='black')
    plt.title("Trending Faults", fontsize=16, fontweight='bold')
    plt.xlabel("Equipment", fontsize=14)
    plt.ylabel("Faults Count", fontsize=14)
    plt.xticks([])
    plt.yticks(fontsize=12)
    plt.grid(color='gray', linestyle='--', linewidth=0.5, axis='y', alpha=0.7)

    fixed_vertical_height = 7

    for bar, label in zip(bars, equipment_names):
        yval = bar.get_height()
        plt.text(bar.get_x() + bar.get_width()/2, yval, int(yval), ha='center', va='bottom', fontsize=10, fontweight='bold')
        plt.text(bar.get_x() + bar.get_width()/2, fixed_vertical_height, label, ha='center', va='bottom', fontsize=8, color='black', rotation=90)

    plt.tight_layout()
    plt.show()

    return plt