from datetime import datetime, timedelta

class SuperWheelsSales:
    def __init__(self, start_date, end_date):
        self.start_date = start_date
        self.end_date = end_date
        self.retail_sales = 0
        self.corporate_sales = 0
        self.monthly_sales = {}
        self.specific_sales = 0
        self.specific_start_date = datetime(2025, 8, 15)
        self.specific_end_date = datetime(2025, 9, 15)

    def get_sales_on_day(self, day_number):

        return 2 * day_number - 1  

    def calculate_sales(self):
        current_date = self.start_date
        day_count = 1

        while current_date <= self.end_date:
            sales_today = self.get_sales_on_day(day_count)
            month = current_date.strftime("%B")

            if month not in self.monthly_sales:
                self.monthly_sales[month] = 0
            self.monthly_sales[month] += sales_today

            if day_count % 5 == 0:
                self.corporate_sales += sales_today
            else:
                self.retail_sales += sales_today

            if self.specific_start_date <= current_date and current_date <= self.specific_end_date:
                self.specific_sales += sales_today

            current_date += timedelta(days=1)
            day_count += 1

    def display_report(self):
        
        print("a. Each month sales:\n")
        for month in ['April', 'May', 'June', 'July', 'August', 'September']:
            print(f"{month}: {self.monthly_sales.get(month, 0)}")

        print(f"total from april to september: {sum(self.monthly_sales.values())}")
        print(f"\nb. total sold to retail customers: {self.retail_sales}")
        print(f"c. total sold to corporate customers: {self.corporate_sales}")
        print(f"d. total sold from aug 15 to sep 15: {self.specific_sales}")


start = datetime(2025, 4, 1)
end = datetime(2025, 9, 30)

obj = SuperWheelsSales(start, end)
obj.calculate_sales()
obj.display_report()

