from functions import EcosysIO, simple_collections
import os
import numpy as np

proj_path = 'daily'

if os.path.isdir(proj_path):
    pass
else:
    os.mkdir(proj_path)
    
def solar_noon(leap,jday,lon):
    hour=12.0
    #calculate fraction of year
    foy=2.0*np.pi*(jday-1.+(hour-12.)/24.)/(365+leap)
    #equation of time (in minutes)
    eqtime=229.18*(0.000075+0.001868*np.cos(foy)-0.032077*np.sin(foy) \
                   -0.014615*np.cos(2.0*foy)-0.040849*np.sin(2.0*foy))
    #return solar in hour
    snoon=(720.-4.*lon-eqtime)/60.
    return snoon

# =======================================================================
#                           --- 使用示例 ---
# =======================================================================
if __name__ == '__main__':

    # 0. 实例化 IO 工具类
    io_handler = EcosysIO()
    oth_handler = simple_collections()

    # 1. 定义所有配置字典

    # 1.1 Runscript 配置
    plant_management_files = ['pft_arctic_p'] * 1
    plant_management_files.extend(['pft_arctic_g']*19)

    my_config = {
        "SETUP_GENERAL": {
            "grid_dims": [1, 1, 1, 1, 1],
            "site_data_file": "site_BR.txt",
            "topography_data_file": "topo_BR.txt",
            "num_scenes": 3,
            "num_runs": 1
        },
        "SETUP_SCENES": {
            "weather_data_files": 'wea1980',
            "weather_options_files": ['opt' + str(i) for i in range(1970, 1990)],
            "land_management_files": 'NO',
            "plant_management_files": plant_management_files,
            "soil_output_1": 'NO',
            "atmospheric_output": 'atm',
            "n_flux_output": 'NO',
            "p_flux_output": 'NO',
            "soil_output_2": 'tsl',
            "soil_output_3": 'eco',
            "water_props_output": 'NO',
            "n_props_output": 'NO',
            "p_props_output": 'NO',
            "t_props_output": 'NO'
        }
    }

    # 1.2 Site Data 配置
    my_site_config = {
        "SITE_PARAMETERS": {
            "latitude": 71.28, "altitude": 10.0, "mean_temp_c": -8, "water_table_flag": 1.0,
            "atm_composition_ppm": [210000.0, 780000.0, 282.9, 1.8, 0.3, 0.005],
            "climate_grid_hydro_params": [61, 0, -1, 1, 100, 100.0, 0.0],
            "bc_surface_runoff_nesw": [0.0, 0.0, 0.0, 0.0],
            "bc_subsurface_flow_nesw": [0.0, 0.0, 0.0, 0.0],
            "dist_water_table_nesw": [0.0, 0.0, 0.0, 0.0],
            "lower_bc_water_flow": 0.0,
            "width_we_column": 1.0, 
            "width_ns_row": 1.0
        }
    }

    # 1.3 Topography Data 配置
    my_topo_config = {
        "TOPOGRAPHY_PARAMETERS": {
            "inner_grid_structure": [1, 1, 1, 1], 
            "landscape_aspect_deg": 0.0,
            "slope_ew_deg": 0.0, 
            "slope_ns_deg": 0.0, 
            "placeholder_value": 0.0,
            "soil_data_file": "soil_BR.txt"
        }
    }

    # 1.4 Soil Data 配置
    
    depth_list = [0.01, 0.055, 0.1, 0.11, 0.155, 0.2, 0.21, 0.255, 0.3, 0.31, 0.355, 0.4, 0.45, 0.5, 0.55, 0.6, 0.7, 0.9, 1.1, 1.3]
    n_depth = len(depth_list)
    
    my_soil_config = {
        "SOIL_GLOBALS": {
            'water_potential_fc_mpa': -0.03, 
            'water_potential_wp_mpa': -1.5, 
            'wet_soil_albedo': 0.12,
            'litter_ph': 3.72, 
            'litter_fine_c': 500.0, 
            'litter_fine_n': 12.5, 
            'litter_fine_p': 1.25,
            'litter_woody_c': 0.0, 
            'litter_woody_n': 0.0, 
            'litter_woody_p': 0.0, 
            'litter_manure_c': 0.0,
            'litter_manure_n': 0.0, 
            'litter_manure_p': 0.0, 
            'litter_type_plant': 10.0,
            'litter_type_manure': 0.0, 
            'num_surface_layers': 1.0, 
            'num_max_rooting_layers': n_depth,
            'num_additional_layers_w_data': 0.0, 
            'num_additional_layers_wo_data': 0.0, 
            'profile_type': 0.0
        },
        
        "SOIL_LAYERS": {
            'layer_depth_bottom_m': depth_list,
            'bulk_density_mg_m3': [0.36, 0.36, 0.42, 0.46, 0.46, 0.58, 0.69, 0.77, 0.79, 0.64, 0.55, 0.36, 0.36, 0.36, 0.79, 0.64, 0.55, 0.36, 0.36, 0.36],
            'field_capacity_m3_m3': [0.38, 0.38, 0.38, 0.43, 0.43, 0.43, 0.47, 0.47, 0.47, 0.43, 0.39, 0.25, 0.25, 0.25, 0.47, 0.43, 0.39, 0.25, 0.25, 0.25], 
            'wilting_point_m3_m3': [0.16, 0.16, 0.16, 0.13, 0.13, 0.13, 0.14, 0.14, 0.14, 0.14, 0.08, 0.11, 0.11, 0.11, 0.14, 0.14, 0.08, 0.11, 0.11, 0.11],
            'vertical_ksat_mm_h': [16.0, 16.0, 16.0, 4.5, 4.5, 4.5, 22.6, 22.6, 22.6, 22.6, 22.6, 545.0, 545.0, 545.0, 22.6, 545.0, 545.0, 545.0, 545.0, 545.0], 
            'lateral_ksat_mm_h': [-1.0]*n_depth,
            'sand_contents_kg_mg': [318, 318, 318, 318, 318, 517, 517, 382, 382, 68, 68, 517, 517, 517, 382, 68, 68, 517, 517, 517],
            'silt_contents_kg_mg': [410, 410, 410, 410, 410, 311, 311, 335, 335, 462, 462, 361, 361, 361, 335, 462, 462, 361, 361, 361],
            'macropore': [0]*n_depth, 
            'rock_fraction': [0]*n_depth,
            'ph': [5.55, 5.55, 5.55, 5.25, 5.25, 5.16, 5.16, 5.16, 5.16, 5.16, 5.16, 5.06, 5.06, 5.06, 5.16, 5.16, 5.16, 5.06, 5.06, 5.06],
            'cation_exchange_capacity': [28.1, 28.1, 28.1, 28.1, 28.1, 28.1, 28.1, 29.9, 20.1, 19.7, 19.7, 19.7, 19.7, 19.7, 20.1, 19.7, 19.7, 19.7, 19.7, 19.7],
            'anion_exchange_capacity': [0]*n_depth,
            'total_soc_kg_mg': [448.0, 448.0, 395.0, 342.0, 343.0, 203.0, 135.0, 124.0, 121.0, 129.0, 123.0, 166.0, 166.0, 166.0, 121.0, 129.0, 123.0, 166.0, 166.0, 166.0],
            'poc_kg_mg': [17.9, 17.9, 15.8, 15.2, 15.2, 10.1, 7.7, 8.3, 8.1, 8.6, 8.2, 11.1, 11.1, 11.1, 8.1, 8.6, 8.2, 11.1, 11.1, 11.1], 
            'son_g_mg': [-1.0]*n_depth, 
            'sop_g_mg': [-1.0]*n_depth,
            'soluble_exch_nh4_g_mg': [0]*n_depth,
            'soluble_exch_no3_g_mg': [0]*n_depth,
            'soluble_exch_h2po4_g_mg': [0]*n_depth,
            'soluble_al_g_mg': [0]*n_depth,  
            'soluble_fe_g_mg': [0]*n_depth, 
            'soluble_ca_g_mg': [0]*n_depth, 
            'soluble_mg_g_mg': [0]*n_depth, 
            'soluble_na_g_mg': [0]*n_depth,
            'soluble_k_g_mg': [0]*n_depth, 
            'soluble_so4s_g_mg': [0]*n_depth,
            'soluble_cl_g_mg': [0]*n_depth, 
            'alpo4_mineral_g_mg': [0]*n_depth,
            'fepo4_mineral_g_mg': [0]*n_depth, 
            'cahpo4_mineral_g_mg': [0]*n_depth,
            'apatite_mineral_g_mg': [0]*n_depth, 
            'aloh3_mineral_g_mg': [0]*n_depth,
            'feoh3_mineral_g_mg': [0]*n_depth, 
            'caso4_mineral_g_mg': [0]*n_depth,
            'caco3_mineral_g_mg': [0]*n_depth, 
            'gapon_ca_nh4': [1]*n_depth,
            'gapon_ca_h': [1]*n_depth, 
            'gapon_ca_al': [1]*n_depth,
            'gapon_ca_mg': [1]*n_depth, 
            'gapon_ca_na': [1]*n_depth,
            'gapon_ca_k': [1]*n_depth,
            'initial_water_contents': [1.0]*n_depth, 
            'initial_ice_contents': [0]*n_depth,
            'initial_c_fine_litter': [0]*n_depth,
            'initial_n_fine_litter': [0]*n_depth,
            'initial_p_fine_litter': [0]*n_depth,
            'initial_c_woody_litter': [0]*n_depth, 
            'initial_n_woody_litter': [0]*n_depth,
            'initial_p_woody_litter': [0]*n_depth, 
            'initial_c_manure_litter': [0]*n_depth,
            'initial_n_manure_litter': [0]*n_depth, 
            'initial_p_manure_litter': [0]*n_depth
        }
    }

    # 1.5 Crop/PFT Configs
    cdl_filepath = "ecosim_pft_20240314.nc.cdl" 
    
    PFTs = ['sedg61','moss61']
        
    for i, pft in enumerate(PFTs):
        
        dump0 = oth_handler.process_cdl_file(cdl_filepath, pft)
                
        if i==0:
            full_pft_config = dump0
        else:
            full_pft_config[pft] = dump0[pft]
    
    # 1.5 定义 grassp 文件的配置字典
    sedg61p_config = {
        "planting": {
            "date_ddmmyyyy": "15039999",
            "initial_density_m2": 800,
            "seeding_depth_m": 0.05
        },
        "harvesting_events": []
    }

    moss61p_config = {
        "planting": {
            "date_ddmmyyyy": "15039999",
            "initial_density_m2": 1E4,
            "seeding_depth_m": 0.01
        },
        "harvesting_events": []
    }

    # 1.6 Plant Management Config
    pft_arctic_p_config = {
        "grid_cell": "1 1 1 1",
        "pft_definitions": [{"crop_file": "sedg61", "planting_file": "sedgp"},
                            {"crop_file": "moss61", "planting_file": "mossp"}
                            ]
    }
    pft_arctic_g_config = {
        "grid_cell": "1 1 1 1",
        "pft_definitions": [{"crop_file": "sedg61", "planting_file": "NO"},
                            {"crop_file": "moss61", "planting_file": "NO"}
                            ]
    }

    # 1.7 Weather Options Config
    opt_base_config = {
        "WEATHER_OPTIONS": {
            'generate_files_data': "NO", 
            'generate_checkpoint': "NO", 
            'resume_from_earlier': "NO",
            'annual_change_params_1': [0.0]*10, 
            'annual_change_params_2': [0.0]*10,
            'annual_change_params_3': [0.0]*10, 
            'annual_change_params_4': [0.0]*10,
            'calc_and_output_freq': [24, 24, 24, 1, 24, 0]
            #     NPX=number of cycles per hour for water,heat,solute flux calcns
            #     NPY=number of cycles per NPX for gas flux calcns
            #     JOUT,IOUT,KOUT=output frequency for hourly,daily,checkpoint data
            #     ICLM=changes to weather data (0=none,1=step,2=transient)
        }
    }

    # 1.8 Weather Header Config
    weather_file_header = {
        "timestep": 'D', 'calendar': 'G', 'num_time_var': '03', 'num_climate': '06',
        'time_format': 'YMD', "variables": "MNHWPR", "variable_units": "KKDSMZ",
        "global_parameters": {
            "windspeed_measurement_height": 10.00, "flag_for_z0g_with_vegetation": 1.00,
            "time_of_solar_noon": 22.4
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
        my_config, os.path.join(proj_path, "runscript_BR.txt"))

    # 2.2 生成 Site, Topography, and Soil data
    io_handler.write_sitedata_from_config(
        my_site_config, os.path.join(proj_path, "site_BR.txt"))
    io_handler.write_topography_from_config(
        my_topo_config, os.path.join(proj_path, "topo_BR.txt"))
    io_handler.write_soildata_from_config(
        my_soil_config, os.path.join(proj_path, "soil_BR.txt"))

    # 2.3 生成植被参数文件
    # io_handler.write_crop_params_from_config(
    #     grass_config, os.path.join(proj_path, "gras61"))
    
    for i, pft in enumerate(PFTs):
        io_handler.write_crop_params_from_config(
            full_pft_config[pft], os.path.join(proj_path, pft))
    
    io_handler.write_planting_data_from_config(
        sedg61p_config, os.path.join(proj_path, "sedgp"))
    
    io_handler.write_planting_data_from_config(
        moss61p_config, os.path.join(proj_path, "mossp"))

    # 2.4 生成植被管理文件
    io_handler.write_plant_management_file(
        pft_arctic_p_config, os.path.join(proj_path, "pft_arctic_p"))
    io_handler.write_plant_management_file(
        pft_arctic_g_config, os.path.join(proj_path, "pft_arctic_g"))

    # 2.5 循环生成多个天气选项文件
    for year in range(1970, 1980):
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

    with open(os.path.join(proj_path, 'atm'), 'wt') as fid:
        fid.write('0101\n3112\n')
        fid.write('YES\n' * 50)
    print("文件已成功生成在: atm")
