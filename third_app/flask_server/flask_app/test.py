from datetime import datetime, timedelta
from supabase import create_client, Client
import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator

url = "https://typmqqidaijuobjosrpi.supabase.co"
key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR5cG1xcWlkYWlqdW9iam9zcnBpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTM0MzkzODAsImV4cCI6MjAwOTAxNTM4MH0.Ihde633Yj9FFaQ7hKLooxDxaFEno4fK8YxSb3gy8S4c"
supabase: Client = create_client(url, key)

current_date = datetime.now().date()
last_week = current_date - timedelta(days=150)

table_name = "FaultData"
rows = supabase.table(table_name).select("*").gte('OccurrenceDate', last_week).execute().data

def faultTable():

    faultsOccurred = 0
    faultsResolved = 0
    faultsPending = 0
    faultsObservation = 0

    for row in rows:
        system = row["System"]
        equipment = row["Equipment"]
        status = row["Status"]

        if system == "Others" or system is None or equipment == "Others" or equipment is None:
            continue
        
        faultsOccurred += 1
        
        if status == 'Resolved':
            faultsResolved += 1
        elif status == 'Pending':
            faultsPending += 1
        elif status == 'Under Observation':
            faultsObservation += 1

    tableData = {
        "Fault Data": ["Faults Occurred", "Faults Resolved", "Faults Pending", "Faults Under Observation"],
        "Number of Faults": [faultsOccurred, faultsResolved, faultsPending, faultsObservation]
    }

    # Create figure and axis
    fig, ax = plt.subplots()

    # Hide axes
    ax.axis('tight')
    ax.axis('off')

    # Create table
    table = ax.table(cellText=list(zip(tableData["Fault Data"], map(str, tableData["Number of Faults"]))),
                    colLabels=["Fault Data", "Number of Faults"],  # Add column labels
                    cellLoc='center',
                    loc='center')

    # Adjust font size
    table.auto_set_font_size(False)
    table.set_fontsize(14)

    # Adjust cell heights
    table.scale(1.2, 1.6)

    # Save graph
    plt.savefig(f'savedGraphs/Fault Table.png')

    systemGraph()

def systemGraph():

    system_faults = {}

    for row in rows:
        system = row["System"]
        equipment = row["Equipment"]

        if system == "Others" or system is None or equipment == "Others" or equipment is None:
            continue

        if system not in system_faults:
            system_faults[system] = 0
        
        system_faults[system] += 1

    # Plotting
    sorted_system = sorted(system_faults.items(), key=lambda x: x[1], reverse=True)
    system_names = [item[0] for item in sorted_system]
    faults_counts = [item[1] for item in sorted_system]

    plt.figure(figsize=(12, 8))
    bars = plt.bar(system_names, faults_counts, color='skyblue', alpha=0.75, edgecolor='black')
    plt.title("System Faults", fontsize=16, fontweight='bold')
    plt.xlabel("System", fontsize=14)
    plt.ylabel("Faults Count", fontsize=14)
    max_faults_count = max(faults_counts)
    plt.xticks([])
    plt.yticks(range(5, max_faults_count + 5), fontsize=12)
    plt.gca().yaxis.set_major_locator(MaxNLocator(integer=True))  # Display only whole number values on y-axis
    plt.grid(color='gray', linestyle='--', linewidth=0.5, axis='y', alpha=0.7)

    fixed_vertical_height = 0.1

    for bar, label in zip(bars, system_names):
        yval = bar.get_height()
        plt.text(bar.get_x() + bar.get_width()/2, yval, int(yval), ha='center', va='bottom', fontsize=10, fontweight='bold')
        plt.text(bar.get_x() + bar.get_width()/2, fixed_vertical_height, label, ha='center', va='bottom', fontsize=10, color='black', rotation=90)

    plt.tight_layout()

    plt.savefig(f'savedGraphs/Systems Graph.png')

    equipmentGraph(system_names)

def equipmentGraph(system_names):

    # print(system_names)

    for savedSystems in system_names:

        equipment_faults = {}

        for row in rows:
            system = row["System"]

            if system == savedSystems:
                equipment = row["Equipment"]

                if system == "Others" or system is None or equipment == "Others" or equipment is None:
                    continue

                if equipment not in equipment_faults:
                    equipment_faults[equipment] = 0
        
                equipment_faults[equipment] += 1

        # Plotting
        sorted_equipment = sorted(equipment_faults.items(), key=lambda x: x[1], reverse=True)
        equipment_names = [item[0] for item in sorted_equipment]
        faults_counts = [item[1] for item in sorted_equipment]

        plt.figure(figsize=(12, 8))
        bars = plt.bar(equipment_names, faults_counts, color='orange', alpha=0.75, edgecolor='black')
        plt.title("Equipment Faults", fontsize=16, fontweight='bold')
        plt.xlabel("Equipment", fontsize=14)
        plt.ylabel("Faults Count", fontsize=14)
        max_faults_count = max(faults_counts)
        plt.xticks([])
        plt.yticks(range(5, max_faults_count + 5), fontsize=12)
        plt.gca().yaxis.set_major_locator(MaxNLocator(integer=True))  # Display only whole number values on y-axis
        plt.grid(color='gray', linestyle='--', linewidth=0.5, axis='y', alpha=0.7)

        fixed_vertical_height = 0.1

        for bar, label in zip(bars, equipment_names):
            yval = bar.get_height()
            plt.text(bar.get_x() + bar.get_width()/2, yval, int(yval), ha='center', va='bottom', fontsize=10, fontweight='bold')
            plt.text(bar.get_x() + bar.get_width()/2, fixed_vertical_height, label, ha='center', va='bottom', fontsize=10, color='black', rotation=90)

        plt.tight_layout()

        # Save the image with a specific name in a local folder
        plt.savefig(f'savedGraphs/{savedSystems}.png')

faultTable()