# Radar Imaging using Time Domain Back Projection (TDBP)

<img width="410" height="304" alt="Despeckled Image" src="https://github.com/user-attachments/assets/7726b8c5-f052-4e18-ad16-764e84a13bb0" />

## Project Structure

| File | Description |
|------|-------------|
| `dataset_UAV.mat` | Dataset containing radar signals, UAV trajectory, reference range axis, etc. |
| `range_resolution.m` | Calculates theoretical range resolution using ΔR = c / (2B) |
| `range_resolution_energy.m` | Estimates bandwidth from signal energy in frequency domain and computes ΔR |
| `tdbp_reconstruction.m` | Main image reconstruction using TDBP + runtime analysis |
| `despeckling.m` | Reduces speckle noise using moving average filters (3×3, 5×5, 7×7) |
| `corner_reflectors.m` | Analyzes focused SAR patch and computes azimuth & range resolution |
| `trajectory_errors.m` | Simulates increasing UAV trajectory noise and visualizes impact on SAR image |
---

## Key Concepts

- **TDBP Algorithm**: High-resolution SAR imaging by integrating radar returns over a 2D grid.
- **Range Resolution**: Assessed using both known bandwidth and estimated from signal FFT.
- **Despeckling**: Moving average filters help reduce speckle noise while preserving detail.
- **Corner Reflectors**: Used to evaluate range and azimuth resolution performance.
- **Trajectory Error Simulation**: Demonstrates how UAV motion errors distort image quality.

---

## How to Run

1. Open MATLAB.
2. Ensure all `.m` files and `dataset_UAV.mat` are in the same folder or in your MATLAB path.
3. Run each script separately to view results:

```matlab
run('range_resolution.m')
run('range_resolution_energy.m')
run('tdbp_reconstruction.m')
run('despeckling.m')
run('corner_reflectors.m')
run('trajectory_errors.m')
