# Data Dictionary

### Gender
- Originally: "Female", "Male", "Other"
- Converted:
    - 0: "Female"
    - 1: "Male"
    - NA: "Other" (if applicable)

### Ever Married
- Originally: "Yes", "No"
- Converted:
    - 1: "Yes"
    - 0: "No"

### Work Type
- Originally: "Private", "children", "Govt_job", "Self-employed", "Never_worked"
- Converted (Numerical Encoding):
    - 1: "Never_worked"
    - 2: "children"
    - 3: "Govt_job"
    - 4: "Private"
    - 5: "Self-employed"

### Residence Type
- Originally: "Urban", "Rural"
- Converted:
    - 1: "Urban"
    - 0: "Rural"

### Smoking Status
- Originally: "formerly smoked", "Unknown", "smokes", "never smoked"
- Converted (Numerical Encoding):
    - 1: "never smoked"
    - 2: "formerly smoked"
    - 3: "smokes"
    - 4: "Unknown"


#### Notes:
- The numerical values assigned to each category are arbitrary and can be adjusted as needed. The key is consistency throughout your analysis.
- For the 'gender' column, the handling of the "Other" category depends on its significance in your analysis and the number of occurrences. If it's a rare category, assigning it as NA (or another unique value) and handling it separately might be appropriate.
- For multi-category variables like 'work_type' and 'smoking_status', the numerical encoding doesn’t imply an ordinal relationship. If your model assumes an ordinal relationship, consider one-hot encoding instead.

