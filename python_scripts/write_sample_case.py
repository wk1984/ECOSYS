from functions import EcosysIO
import os

proj_path = '.'

# =======================================================================
#                           --- 使用示例 ---
# =======================================================================
if __name__ == '__main__':

    # 0. 实例化 IO 工具类
    io_handler = EcosysIO()

    # 1. 定义所有配置字典

    # 1.1 Runscript 配置
    plant_management_files = ['pft_arctic_p'] * 1
    plant_management_files.extend(['pft_arctic_g']*5)

    my_config = {
        "SETUP_GENERAL": {
            "grid_dims": [1, 1, 1, 1, 1],
            "site_data_file": "st022852.txt",
            "topography_data_file": "tp022852.txt",
            "num_scenes": 6,
            "num_runs": 1
        },
        "SETUP_SCENES": {
            "weather_data_files": 'w1980022852',
            "weather_options_files": ['opt1800', 'opt1801', 'opt1802', 'opt1803', 'opt1804', 'opt1805'],
            "land_management_files": 'NO',
            "plant_management_files": plant_management_files,
            "soil_output_1": 'NO',
            "atmospheric_output": 'NO',
            "n_flux_output": 'NO',
            "p_flux_output": 'NO',
            "soil_output_2": 'tsl',
            "soil_output_3": 'eco',
            "water_props_output": 'wat',
            "n_props_output": 'NO',
            "p_props_output": 'NO',
            "t_props_output": 'NO'
        }
    }

    # 1.2 Site Data 配置
    my_site_config = {
        "SITE_PARAMETERS": {
            "latitude": 69.1, "altitude": 130.0, "mean_temp_c": -8.0, "water_table_flag": 1.0,
            "atm_composition_ppm": [210000.0, 780000.0, 282.9, 1.8, 0.3, 0.005],
            "climate_grid_hydro_params": [62, 0, -1, 1, 3, 100.0, 0.0],
            "bc_surface_runoff_nesw": [0.0, 0.0, 0.0, 0.0],
            "bc_subsurface_flow_nesw": [0.0, 0.0, 0.0, 0.0],
            "dist_water_table_nesw": [0.0, 0.0, 0.0, 0.0],
            "lower_bc_water_flow": 0.0,
            "width_we_column": 1.0, "width_ns_row": 1.0
        }
    }

    # 1.3 Topography Data 配置
    my_topo_config = {
        "TOPOGRAPHY_PARAMETERS": {
            "inner_grid_structure": [1, 1, 1, 1], "landscape_aspect_deg": 90.0,
            "slope_ew_deg": 1.0, "slope_ns_deg": 0.01, "placeholder_value": 0.0,
            "soil_data_file": "s022852.txt"
        }
    }

    # 1.4 Soil Data 配置
    my_soil_config = {
        "SOIL_GLOBALS": {
            'water_potential_fc_mpa': -0.03, 'water_potential_wp_mpa': -1.5, 'wet_soil_albedo': 0.12,
            'litter_ph': 3.72, 'litter_fine_c': 500.0, 'litter_fine_n': 12.5, 'litter_fine_p': 1.25,
            'litter_woody_c': 0.0, 'litter_woody_n': 0.0, 'litter_woody_p': 0.0, 'litter_manure_c': 0.0,
            'litter_manure_n': 0.0, 'litter_manure_p': 0.0, 'litter_type_plant': 10.0,
            'litter_type_manure': 0.0, 
            'num_surface_layers': 1.0, 
            'num_max_rooting_layers': 8.0,
            'num_additional_layers_w_data': 0.0, 
            'num_additional_layers_wo_data': 0.0, 
            'profile_type': 1.0
        },
        "SOIL_LAYERS": {
            'layer_depth_bottom_m': [0.01, 0.05, 0.15, 0.3, 0.5, 0.7, 1.16, 1.52] + [0.0]*12,
            'bulk_density_mg_m3': [1.1, 1.1, 1.21, 1.21, 1.47, 1.47, 1.47, 1.47] + [0.0]*12,
            'field_capacity_m3_m3': [-1.0]*20, 
            'wilting_point_m3_m3': [-1.0]*20,
            'vertical_ksat_mm_h': [-1.0]*20, 
            'lateral_ksat_mm_h': [-1.0]*20,
            'sand_contents_kg_mg': [319.71]*4 + [330.14]*4 + [180.0]*4 + [0.0]*8,
            'silt_contents_kg_mg': [545.39]*4 + [184.49]*4 + [20.0]*4 + [0.0]*8,
            'macropore': [0.0]*20, 
            'rock_fraction': [0.0]*20,
            'ph': [5.77]*4 + [5.8]*4 + [4.35]*8 + [0.0]*4,
            'cation_exchange_capacity': [10.0]*8 + [5.0]*4 + [0.0]*8,
            'anion_exchange_capacity': [3.0]*12 + [0.0]*8,
            'total_soc_kg_mg': [3.87, 2.87, 2.6, 2.6, 2.0, 2.0, 2.0, 2.0, 3.0, 0.5, 0.5] + [0.0]*9,
            'poc_kg_mg': [0.0]*20, 
            'son_g_mg': [-1.0]*20, 
            'sop_g_mg': [-1.0]*20,
            'soluble_exch_nh4_g_mg': [3.0]*3 + [1.0]*3 + [0.0]*14,
            'soluble_exch_no3_g_mg': [12.0]*3 + [1.0]*3 + [0.0]*14,
            'soluble_exch_h2po4_g_mg': [10.0]*12 + [0.0]*8,
            'soluble_al_g_mg': [-1.0]*12 + [0.0]*8, 
            'soluble_fe_g_mg': [-1.0]*12 + [0.0]*8,
            'soluble_ca_g_mg': [40.0]*20, 
            'soluble_mg_g_mg': [0.0]*3 + [18.0]*3 + [0.0]*14,
            'soluble_na_g_mg': [0.07]*3 + [0.05]*3 + [0.01]*6 + [0.0]*8,
            'soluble_k_g_mg': [0.0]*20, 
            'soluble_so4s_g_mg': [48.0]*12 + [0.0]*8,
            'soluble_cl_g_mg': [35.0]*12 + [0.0]*8, 
            'alpo4_mineral_g_mg': [50.0]*12 + [0.0]*8,
            'fepo4_mineral_g_mg': [50.0]*12 + [0.0]*8, 
            'cahpo4_mineral_g_mg': [0.0]*20,
            'apatite_mineral_g_mg': [0.0]*20, 
            'aloh3_mineral_g_mg': [1000.0]*12 + [0.0]*8,
            'feoh3_mineral_g_mg': [1000.0]*12 + [0.0]*8, 
            'caso4_mineral_g_mg': [0.0]*20,
            'caco3_mineral_g_mg': [0.0]*20, 
            'gapon_ca_nh4': [1.0]*20,
            'gapon_ca_h': [0.25]*12 + [0.0]*8, 
            'gapon_ca_al': [0.25]*12 + [0.0]*8,
            'gapon_ca_mg': [0.6]*12 + [0.0]*8, 
            'gapon_ca_na': [0.16]*12 + [0.0]*8,
            'gapon_ca_k': [3.0]*12 + [0.0]*8,
            'initial_water_contents': [1.0]*12 + [0.0]*8, 
            'initial_ice_contents': [0.0]*20,
            'initial_c_fine_litter': [45.0, 60.0, 75.0, 75.0, 60.0, 60.0, 45.0, 45.0, 15.0] + [0.0]*11,
            'initial_n_fine_litter': [1.5, 2.0, 2.5, 2.5, 2.0, 2.0, 1.5, 1.5, 0.5] + [0.0]*11,
            'initial_p_fine_litter': [0.15, 0.2, 0.25, 0.25, 0.2, 0.2, 0.15, 0.15, 0.05] + [0.0]*11,
            'initial_c_woody_litter': [0.0]*20, 
            'initial_n_woody_litter': [0.0]*20,
            'initial_p_woody_litter': [0.0]*20, 
            'initial_c_manure_litter': [0.0]*20,
            'initial_n_manure_litter': [0.0]*20, 
            'initial_p_manure_litter': [0.0]*20
        }
    }

    # 1.5 Crop/PFT Configs
    grass62_config = {
        "CROP_PARAMETERS": {
            'biology_and_phenology': [3, 1, 1, 0, 0, 1, 2, 0, 0, 2, 1.50],
            'photosynthesis_biochem': [45.0, 9.5, 0.0, 12.5, 500.0, 0.0, 0.125, 0.0, 405.0, 0.025, 0.0, 0.70],
            'leaf_optical_props': [0.150, 0.075, 0.150, 0.075],
            'development_and_temp': [0.015, 0.009, -10.0, 420.0, 720.0, 5.0, 0.10],
            'flowering_and_photoperiod': [6.5, 2.5, -1.0, 0.5],
            'organ_growth': [0.00333, 0.125, 0.15],
            'canopy_structure': [0.00, 0.00, 0.50, 0.50, 0.90, 90.0, 90.0],
            'seed_and_establishment': [5.0, 5.0, 0.005, 0.005, 1.25E-05, 0.0],
            'root_properties': [1.0E-04, 1.0E-04, 0.05, 0.10, 1.0E+04, 4.0E+09, 5.0E-02, 250.0, 250.0],
            'nh4_uptake_kinetics': [5.0E-03, 0.40, 0.0125], 'no3_uptake_kinetics': [5.0E-03, 0.35, 0.030],
            'h2po4_uptake_kinetics': [1.0E-03, 0.075, 0.002], 'water_relations': [-1.25, -5.0, 2.5E+03],
            'organ_growth_yield': [7.2E-01, 7.6E-01, 8.0E-01, 8.8E-01, 7.6E-01, 7.6E-01, 8.8E-01, 7.6E-01, 7.2E-01],
            'organ_nc_ratio': [10.0E-02, 2.0E-02, 1.0E-02, 2.0E-02, 2.0E-02, 2.0E-02, 4.0E-02, 2.5E-02, 10.0E-02],
            'organ_pc_ratio': [10.0E-03, 2.0E-03, 1.0E-03, 2.0E-03, 2.0E-03, 2.0E-03, 4.0E-03, 2.5E-03, 10.0E-03]
        }
    }

    # 1.5 定义 grassp 文件的配置字典
    grassp_config = {
        "planting": {
            "date_ddmmyyyy": "15039999",
            "initial_density_m2": 1000,
            "seeding_depth_m": 0.001
        },
        "harvesting_events": []
    }

    # 1.6 Plant Management Config
    pft_arctic_p_config = {
        "grid_cell": "1 1 1 1",
        "pft_definitions": [{"crop_file": "gras62", "planting_file": "grassp"}]
    }
    pft_arctic_g_config = {
        "grid_cell": "1 1 1 1",
        "pft_definitions": [{"crop_file": "gras62", "planting_file": "NO"}]
    }

    # 1.7 Weather Options Config
    opt_base_config = {
        "WEATHER_OPTIONS": {
            'generate_files_data': "NO", 'generate_checkpoint': "NO", 'resume_from_earlier': "NO",
            'annual_change_params_1': [0.0]*10, 'annual_change_params_2': [0.0]*10,
            'annual_change_params_3': [0.0]*10, 'annual_change_params_4': [0.0]*10,
            'calc_and_output_freq': [24, 24, 24, 1, -1, 0]
        }
    }

    # 1.8 Weather Header Config
    weather_file_header = {
        "timestep": '3', 'calendar': 'J', 'num_time_var': '03', 'num_climate': '05',
        'time_format': 'XDH', "variables": "THWPR", "variable_units": "KRSMW",
        "global_parameters": {
            "windspeed_measurement_height": 10.00, "flag_for_z0g_with_vegetation": 1.00,
            "time_of_solar_noon": 22.04
        },
        "precipitation_chemistry": {
            "pH": 7.00, "NH4_concentration": 0.02, "NO3_concentration": 0.07,
            "H2PO4_concentration": 0.00, "Al_concentration": 0.00, "Fe_concentration": 0.00,
            "Ca_concentration": 0.00, "Mg_concentration": 0.00, "Na_concentration": 0.00,
            "K_concentration": 0.00, "SO4_concentration": 0.00, "Cl_concentration": 0.00,
            "undefined_parameter": 0.00
        }
    }

    # 2. 调用方法生成文件

    # 2.1 生成 Runscript
    io_handler.write_runscript_from_config(
        my_config, os.path.join(proj_path, "runscript_generated.txt"))

    # 2.2 生成 Site, Topography, and Soil data
    io_handler.write_sitedata_from_config(
        my_site_config, os.path.join(proj_path, "st022852.txt"))
    io_handler.write_topography_from_config(
        my_topo_config, os.path.join(proj_path, "tp022852.txt"))
    io_handler.write_soildata_from_config(
        my_soil_config, os.path.join(proj_path, "s022852.txt"))

    # 2.3 生成植被参数文件
    io_handler.write_crop_params_from_config(
        grass62_config, os.path.join(proj_path, "gras62"))
    io_handler.write_planting_data_from_config(
        grassp_config, os.path.join(proj_path, "grassp"))

    # 2.4 生成植被管理文件
    io_handler.write_plant_management_file(
        pft_arctic_p_config, os.path.join(proj_path, "pft_arctic_p"))
    io_handler.write_plant_management_file(
        pft_arctic_g_config, os.path.join(proj_path, "pft_arctic_g"))

    # 2.5 循环生成多个天气选项文件
    for year in range(1800, 1806):
        opt_config = opt_base_config.copy()
        opt_config['WEATHER_OPTIONS']['scenario_start_date'] = f"0101{year}"
        opt_config['WEATHER_OPTIONS']['scenario_end_date'] = f"3112{year}"
        opt_config['WEATHER_OPTIONS']['run_start_date'] = f"0101{year}"
        io_handler.write_weather_options_from_config(
            opt_config, os.path.join(proj_path, f"opt{year}"))

    # 2.6 生成天气文件头
    # 注意: 实际的天气数据需要另外生成并追加到此文件
    io_handler.write_weather_header_from_dict(weather_file_header)

    # 2.7 生成简单的输出定义文件
    with open(os.path.join(proj_path, 'tsl'), 'wt') as fid:
        fid.write('0101\n3112\n')
        fid.write('YES\n' * 35)
    print("文件已成功生成在: tsl")

    with open(os.path.join(proj_path, 'eco'), 'wt') as fid:
        fid.write('0101\n3112\n')
        fid.write('YES\n' * 17)  # FIRE_CO2
        fid.write('YES\n' * 10)  # SOC 1-20
        fid.write('NO\n' * 10)  # SOC 1-20
        fid.write('NO\n' * 3)   # TEMP 5-7
        fid.write('YES\n' * 10)
    print("文件已成功生成在: eco")

    with open(os.path.join(proj_path, 'wat'), 'wt') as fid:
        fid.write('0101\n3112\n')
        fid.write('YES\n' * 50)
    print("文件已成功生成在: wat")
