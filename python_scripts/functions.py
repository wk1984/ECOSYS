import collections.abc

import re
import os
import pandas as pd

class simple_collections:
    
    def cdl_to_pft_dict(self, cdl_content: str, pft_name_to_extract: str) -> dict:
        """
        解析 CDL 字符串内容，并为指定的 PFT 提取参数，汇总到一个格式化的字典中。
        (此函数与之前版本相同)
        """
        try:
            data_section = cdl_content.split('data:')[1]
            data_section = data_section.rsplit('}', 1)[0]
        except IndexError:
            return {}
    
        variable_pattern = re.compile(r'\b([a-zA-Z0-9_]+)\s*=\s*(.*?);', re.DOTALL)
        
        variables = {}
        matches = variable_pattern.finditer(data_section)
        for match in matches:
            var_name = match.group(1).strip()
            values_str = match.group(2).strip()
            
            if '"' in values_str:
                variables[var_name] = [v.strip() for v in re.findall(r'"(.*?)"', values_str, re.DOTALL)]
                continue
    
            cleaned_str = ' '.join(values_str.replace('\n', ' ').replace(',', ' ').split())
            value_list = cleaned_str.split(' ')
            
            numeric_values = []
            for val in value_list:
                if val:
                    try:
                        numeric_values.append(float(val))
                    except ValueError:
                        pass
            variables[var_name] = numeric_values
                
        pft_names = variables.get('pfts')
        if not pft_names:
            return {"error": "'pfts' 变量未在 CDL 数据中找到。"}
            
        try:
            pft_index = pft_names.index(pft_name_to_extract)
        except ValueError:
            return {"error": f"PFT '{pft_name_to_extract}' 在 PFT 列表中未找到。"}
    
        param_map = {
            'biology_and_phenology': ['ICTYP', 'IGTYP', 'ISTYP', 'IDTYP', 'INTYP', 'IWTYP', 'IPTYP', 'IBTYP', 'IRTYP', 'MY', 'ZTYPI'],
            'photosynthesis_biochem': ['VCMX', 'VOMX', 'VCMX4', 'XKCO2', 'XKO2', 'XKCO24', 'RUBP', 'PEPC', 'ETMX', 'CHL', 'CHL4', 'FCO2'],
            'leaf_optical_props': ['ALBR', 'ALBP', 'TAUR', 'TAUP'],
            'development_and_temp': ['XRNI', 'XRLA', 'CTC', 'VRNLI', 'VRNXI', 'WDLF', 'PB'],
            'flowering_and_photoperiod': ['GROUPX', 'XTLI', 'XDL', 'XPPD'],
            'organ_growth': ['SLA1', 'SSL1', 'SNL1'],
            'canopy_structure': ['CFI', 'ANGBR', 'ANGSH'],
            'seed_and_establishment': ['STMX', 'SDMX', 'GRMX', 'GRDM', 'GFILL', 'WTSTDI'],
            'root_properties': ['RRAD1M', 'RRAD2M', 'PORT', 'PR', 'RSRR', 'RSRA', 'PTSHT', 'RTFQ'],
            'nh4_uptake_kinetics': ['UPMXZH', 'UPKMZH', 'UPMNZH'],
            'no3_uptake_kinetics': ['UPMXZO', 'UPKMZO', 'UPMNZO'],
            'h2po4_uptake_kinetics': ['UPMXPO', 'UPKMPO', 'UPMNPO'],
            'water_relations': ['OSMO', 'RCS', 'RSMX'],
            'organ_growth_yield': ['DMLF', 'DMSHE', 'DMSTK', 'DMRSV', 'DMHSK', 'DMEAR', 'DMGR', 'DMRT', 'DMND'],
            'organ_nc_ratio': ['CNLF', 'CNSHE', 'CNSTK', 'CNRSV', 'CNHSK', 'CNEAR', 'CNGR', 'CNRT', 'CNND'],
            'organ_pc_ratio': ['CPLF', 'CPSHE', 'CPSTK', 'CPRSV', 'CPHSK', 'CPEAR', 'CPGR', 'CPRT', 'CPND']
        }
        
        pft_params = {}
        for category, var_list in param_map.items():
            pft_params[category] = []
            for var_name in var_list:
                if var_name in variables:
                    if pft_index < len(variables[var_name]):
                        value = variables[var_name][pft_index]
                        if isinstance(value, float) and value.is_integer():
                             pft_params[category].append(int(value))
                        else:
                             pft_params[category].append(value)
    
        if 'CLASS' in variables:
            class_values = variables['CLASS']
            jli_dim = 4
            start_index = pft_index * jli_dim
            end_index = start_index + jli_dim
            if end_index <= len(class_values):
                class_data_for_pft = [int(v) if float(v).is_integer() else v for v in class_values[start_index:end_index]]
                pft_params['canopy_structure'] = class_data_for_pft + pft_params['canopy_structure']
    
        final_dict = {
            pft_name_to_extract: {
                "CROP_PARAMETERS": pft_params
            }
        }
        return final_dict
        
    # --- 新增的主函数 ---
    def process_cdl_file(self, cdl_filepath: str, pft_name_to_extract: str, output_dir: str = '.'):
        """
        从CDL文件读取数据，处理指定的PFT，并生成参数文件。
    
        Args:
            cdl_filepath (str): 输入的CDL文件路径。
            pft_name_to_extract (str): 需要提取参数的PFT名称。
            output_dir (str, optional): 输出目录。默认为当前目录。
        """
        print(f"\n--- 开始处理 PFT: {pft_name_to_extract} ---")
        # 1. 从文件读取CDL内容
        try:
            with open(cdl_filepath, 'r', encoding='utf-8') as f:
                cdl_content = f.read()
            print(f"成功读取文件: {cdl_filepath}")
        except FileNotFoundError:
            print(f"错误: 文件未找到于 '{cdl_filepath}'")
            return
        except Exception as e:
            print(f"读取文件时发生错误: {e}")
            return
    
        # 2. 调用解析函数生成配置字典
        full_config = self.cdl_to_pft_dict(cdl_content, pft_name_to_extract)
            
        return full_config

    def merge_mult_files(self, year_list, prefix = '01010', subfix='tsl', workdir='.'):
        for i,yr in enumerate(year_list):
            df1 = self.read_data_file_robust(os.path.join(workdir, prefix+str(yr)+subfix))
            if i==0:
                out = df1.copy()
            else:
                out = pd.concat([out, df1], ignore_index=True)
    
        return out
    
    def read_data_file_robust(self, file_content, header_lines = 1, nanflag = -9999.0):


        
        """
        一个更强大的函数，用于读取具有多行标题的固定宽度文件。
        该函数会自动解析标题，读取数据，并将'DATE'列转换为日期时间对象。

        参数:
        file_content (str): 文件的文本内容。
        header_lines (int): 构成标题的总行数。

        返回:
        pandas.DataFrame: 包含正确列名和格式化日期列的DataFrame。
        """

        # --- 步骤 1: 读取并解析标题 ---

        fid = open(file_content)
        lines = fid.readline()
        # print(lines)
        fid.close()
        column_headlines = lines.split()
        
        # 从数据开始的第一行读取，跳过所有标题行
        df = pd.read_csv(file_content, 
                         delim_whitespace=True, 
                         skiprows=header_lines, 
                         header=None, na_values = nanflag)
        
        # 获取实际读取到的数据列数
        num_data_columns = df.shape[1]
        
        # 为 DataFrame 分配列名
        num_headlines = len(column_headlines)
        if num_headlines == num_data_columns:
            df.columns = column_headlines
        else:
            # 如果列名和数据列数不匹配，则只命名匹配的部分，避免错误
            df.columns = column_headlines[:num_data_columns]

        # --- 新增步骤: 转换 DATE 列 ---
        
        # 检查 'DATE' 列是否存在
        if 'DATE' in df.columns:
            # 确保该列是字符串类型，以便进行处理
            df['DATE'] = df['DATE'].astype(str)
            # 补全可能缺失的前导零 (例如，日期为 1011801 而不是 01011801)
            df['DATE'] = df['DATE'].str.zfill(8)
            # 将字符串转换为日期时间对象，格式为 DDMMYYYY
            df['DATE'] = pd.to_datetime(df['DATE'], format='%d%m%Y')
                
        return df


class EcosysIO:
    """
    一个用于处理与 ecosys 模型相关的各类输入文件读写的工具类。

    该类将不同的文件生成函数（如 runscript, site data, soil data 等）
    封装为方法，以便于通过一个统一的接口进行调用。
    """

    def write_runscript_from_config(self, config_data: dict, output_path: str):
        """
        根据配置字典生成一个类似 runscript_test 的固定格式运行文件。
        该版本能处理值为列表（每场景不同）或字符串（所有场景通用）的参数。

        参数:
        config_data (dict): 包含所有模拟参数的字典。
        output_path (str): 输出文件的路径。
        """
        lines = []

        # --- 1. 提取通用设置 ---
        general_config = config_data.get("SETUP_GENERAL", {})

        grid_line = ' '.join(
            map(str, general_config.get("grid_dims", [1, 1, 1, 1, 1])))
        lines.append(grid_line)

        lines.append(general_config.get("site_data_file"))
        lines.append(general_config.get("topography_data_file"))

        num_scenes = general_config.get("num_scenes", 0)
        num_runs = general_config.get("num_runs", 1)
        lines.append(f"{num_scenes} {num_runs}")

        # --- 2. 循环处理每个场景 ---
        scenes_config = config_data.get("SETUP_SCENES", {})
        scene_file_keys = [
            "weather_data_files", "weather_options_files", "land_management_files",
            "plant_management_files", "soil_output_1", "atmospheric_output",
            "n_flux_output", "p_flux_output", "soil_output_2", "soil_output_3",
            "water_props_output", "n_props_output", "p_props_output", "t_props_output"
        ]

        for i in range(num_scenes):
            lines.append("1 1")

            for key in scene_file_keys:
                config_value = scenes_config.get(key)

                if isinstance(config_value, list):
                    if i < len(config_value):
                        lines.append(config_value[i])
                    else:
                        lines.append("NO_FILE_SPECIFIED_IN_LIST")
                elif isinstance(config_value, str):
                    lines.append(config_value)
                else:
                    lines.append("NO_FILE_SPECIFIED")

        # --- 3. 添加结束标志 ---
        lines.append("0 0")

        # --- 4. 将所有行写入文件 ---
        try:
            with open(output_path, 'w') as f:
                f.write('\n'.join(lines))
            print(f"文件已成功生成在: {output_path}")
        except IOError as e:
            print(f"写入文件时出错: {e}")

    def write_sitedata_from_config(self, config_data: dict, output_path: str):
        """
        根据配置字典生成一个 site_data 格式的文件。

        参数:
        config_data (dict): 包含所有站点参数的字典。
        output_path (str): 输出文件的路径。
        """
        lines = []
        params = config_data.get("SITE_PARAMETERS", {})

        line1 = (f"{params.get('latitude', 0.0)} {params.get('altitude', 0.0)} "
                 f"{params.get('mean_temp_c', 0.0)} {params.get('water_table_flag', 0.0)}")
        lines.append(line1)

        atm_comp = params.get('atm_composition_ppm', [])
        lines.append(' '.join(map(str, atm_comp)))

        cgh_params = params.get('climate_grid_hydro_params', [])
        lines.append(' '.join(map(str, cgh_params)))

        bc_surf = params.get('bc_surface_runoff_nesw', [0.0]*4)
        bc_sub = params.get('bc_subsurface_flow_nesw', [0.0]*4)
        dist_wt = params.get('dist_water_table_nesw', [0.0]*4)
        lower_bc = params.get('lower_bc_water_flow', 0.0)

        if not isinstance(lower_bc, collections.abc.Iterable):
            lower_bc = [lower_bc]

        full_bc_line_values = list(
            bc_surf) + list(bc_sub) + list(dist_wt) + list(lower_bc)
        lines.append(' '.join(map(str, full_bc_line_values)))

        lines.append(str(params.get('width_we_column', 1.0)))
        lines.append(str(params.get('width_ns_row', 1.0)))

        try:
            with open(output_path, 'w') as f:
                f.write('\n'.join(lines))
            print(f"文件已成功生成在: {output_path}")
        except IOError as e:
            print(f"写入文件时出错: {e}")

    def write_topography_from_config(self, config_data: dict, output_path: str):
        """
        根据配置字典生成一个 topography_data 格式的文件。

        参数:
        config_data (dict): 包含所有地形参数的字典。
        output_path (str): 输出文件的路径。
        """
        lines = []
        params = config_data.get("TOPOGRAPHY_PARAMETERS", {})

        grid_struct = params.get('inner_grid_structure', [1, 1, 1, 1])
        aspect = params.get('landscape_aspect_deg', 0.0)
        slope_ew = params.get('slope_ew_deg', 0.0)
        slope_ns = params.get('slope_ns_deg', 0.0)
        placeholder = params.get('placeholder_value', 0.0)

        line1_values = list(grid_struct) + \
            [aspect, slope_ew, slope_ns, placeholder]
        lines.append(' '.join(map(str, line1_values)))

        soil_file = params.get('soil_data_file', 'default_soil.txt')
        lines.append(soil_file)

        try:
            with open(output_path, 'w') as f:
                f.write('\n'.join(lines))
            print(f"文件已成功生成在: {output_path}")
        except IOError as e:
            print(f"写入文件时出错: {e}")

    def write_soildata_from_config(self, config_data: dict, output_path: str):
        """
        根据配置字典生成一个 soil_data 格式的文件。

        参数:
        config_data (dict): 包含所有土壤参数的字典。
        output_path (str): 输出文件的路径。
        """
        lines = []
        globals_params = config_data.get("SOIL_GLOBALS", {})
        layers_params = config_data.get("SOIL_LAYERS", {})

        global_keys_in_order = [
            'water_potential_fc_mpa', 'water_potential_wp_mpa', 'wet_soil_albedo',
            'litter_ph', 'litter_fine_c', 'litter_fine_n', 'litter_fine_p',
            'litter_woody_c', 'litter_woody_n', 'litter_woody_p', 'litter_manure_c',
            'litter_manure_n', 'litter_manure_p', 'litter_type_plant',
            'litter_type_manure', 'num_surface_layers', 'num_max_rooting_layers',
            'num_additional_layers_w_data', 'num_additional_layers_wo_data',
            'profile_type'
        ]
        global_values = [globals_params.get(
            key, 0.0) for key in global_keys_in_order]
        lines.append(','.join(map(str, global_values)))

        layer_keys_in_order = [
            'layer_depth_bottom_m', 'bulk_density_mg_m3', 'field_capacity_m3_m3',
            'wilting_point_m3_m3', 'vertical_ksat_mm_h', 'lateral_ksat_mm_h',
            'sand_contents_kg_mg', 'silt_contents_kg_mg', 'macropore', 'rock_fraction',
            'ph', 'cation_exchange_capacity', 'anion_exchange_capacity',
            'total_soc_kg_mg', 'poc_kg_mg', 'son_g_mg', 'sop_g_mg',
            'soluble_exch_nh4_g_mg', 'soluble_exch_no3_g_mg', 'soluble_exch_h2po4_g_mg',
            'soluble_al_g_mg', 'soluble_fe_g_mg', 'soluble_ca_g_mg', 'soluble_mg_g_mg',
            'soluble_na_g_mg', 'soluble_k_g_mg', 'soluble_so4s_g_mg', 'soluble_cl_g_mg',
            'alpo4_mineral_g_mg', 'fepo4_mineral_g_mg', 'cahpo4_mineral_g_mg',
            'apatite_mineral_g_mg', 'aloh3_mineral_g_mg', 'feoh3_mineral_g_mg',
            'caso4_mineral_g_mg', 'caco3_mineral_g_mg', 'gapon_ca_nh4', 'gapon_ca_h',
            'gapon_ca_al', 'gapon_ca_mg', 'gapon_ca_na', 'gapon_ca_k',
            'initial_water_contents', 'initial_ice_contents', 'initial_c_fine_litter',
            'initial_n_fine_litter', 'initial_p_fine_litter', 'initial_c_woody_litter',
            'initial_n_woody_litter', 'initial_p_woody_litter',
            'initial_c_manure_litter', 'initial_n_manure_litter', 'initial_p_manure_litter'
        ]
        for key in layer_keys_in_order:
            layer_values = layers_params.get(key, [])
            lines.append(','.join(map(str, layer_values)))

        try:
            with open(output_path, 'w') as f:
                f.write('\n'.join(lines))
            print(f"文件已成功生成在: {output_path}")
        except IOError as e:
            print(f"写入文件时出错: {e}")

    def write_crop_params_from_config(self, config_data: dict, output_path: str):
        """
        根据配置字典生成一个作物/植被参数格式的文件。

        参数:
        config_data (dict): 包含所有作物参数的字典。
        output_path (str): 输出文件的路径。
        """
        lines = []
        params = config_data.get("CROP_PARAMETERS", {})

        keys_in_order = [
            'biology_and_phenology', 'photosynthesis_biochem', 'leaf_optical_props',
            'development_and_temp', 'flowering_and_photoperiod', 'organ_growth',
            'canopy_structure', 'seed_and_establishment', 'root_properties',
            'nh4_uptake_kinetics', 'no3_uptake_kinetics', 'h2po4_uptake_kinetics',
            'water_relations', 'organ_growth_yield', 'organ_nc_ratio',
            'organ_pc_ratio'
        ]

        for key in keys_in_order:
            values = params.get(key, [])
            formatted_values = []
            for v in values:
                if isinstance(v, float) and (v < 1e-3 or v > 1e4) and v != 0.0:
                    formatted_values.append(f"{v:.1E}".replace(
                        "E-0", "E-").replace("E+0", "E+"))
                else:
                    formatted_values.append(str(v))
            lines.append(' '.join(formatted_values))

        try:
            with open(output_path, 'w') as f:
                f.write('\n'.join(lines))
            print(f"文件已成功生成在: {output_path}")
        except IOError as e:
            print(f"写入文件时出错: {e}")

    def write_plant_management_file(self, config_data: dict, output_path: str):
        """
        根据配置字典生成一个 plant_management 格式的文件。

        参数:
        config_data (dict): 包含所有植被管理参数的字典。
        output_path (str): 输出文件的路径。
        """
        lines = []

        grid_cell = config_data.get('grid_cell', '1 1 1 1')
        pft_definitions = config_data.get('pft_definitions', [])
        pft_count = len(pft_definitions)

        line1 = f"{grid_cell} {pft_count}"
        lines.append(line1)

        line2_parts = []
        for pft in pft_definitions:
            crop_file = pft.get('crop_file', 'unknown_crop')
            planting_file = pft.get('planting_file', 'unknown_planting')
            line2_parts.append(crop_file)
            line2_parts.append(planting_file)

        lines.append(' '.join(line2_parts))

        try:
            with open(output_path, 'w') as f:
                f.write('\n'.join(lines))
            print(f"文件已成功生成在: {output_path}")
        except IOError as e:
            print(f"写入文件时出错: {e}")

    def write_planting_data_from_config(self, config_data: dict, output_path: str):
        """
        根据配置字典生成一个 planting_data 格式的文件 (如 grassp)。
        这个函数目前只处理种植行，因为示例文件中不包含收获事件。

        参数:
        config_data (dict): 包含所有种植参数的字典。
        output_path (str): 输出文件的路径。
        """
        lines = []

        # --- 1. 构造第一行: 种植参数 ---
        planting_info = config_data.get("planting", {})
        if planting_info:
            line1_values = [
                planting_info.get("date_ddmmyyyy", "01019999"),
                planting_info.get("initial_density_m2", 0),
                planting_info.get("seeding_depth_m", 0.0)
            ]
            lines.append(' '.join(map(str, line1_values)))

        # --- (可选) 构造收获/放牧行 ---
        # 这个函数可以被扩展来处理收获事件，但对于 grassp 文件，这部分会跳过。
        harvesting_events = config_data.get("harvesting_events", [])
        for event in harvesting_events:
            # 在这里添加逻辑来构建收获事件行
            pass

        # --- 2. 写入文件 ---
        try:
            with open(output_path, 'w') as f:
                f.write('\n'.join(lines))
            print(f"文件已成功生成在: {output_path}")
        except IOError as e:
            print(f"写入文件时出错: {e}")

    def write_weather_options_from_config(self, config_data: dict, output_path: str):
        """
        根据配置字典生成一个 weather_options 格式的文件。

        参数:
        config_data (dict): 包含所有天气选项参数的字典。
        output_path (str): 输出文件的路径。
        """
        lines = []
        params = config_data.get("WEATHER_OPTIONS", {})

        keys_in_order = [
            'scenario_start_date', 'scenario_end_date', 'run_start_date',
            'generate_files_data', 'generate_checkpoint', 'resume_from_earlier',
            'annual_change_params_1', 'annual_change_params_2', 'annual_change_params_3', 'annual_change_params_4',
            'calc_and_output_freq'
        ]

        for key in keys_in_order:
            value = params.get(key)
            if isinstance(value, list):
                lines.append(','.join(map(str, value)))
            elif value is not None:
                lines.append(str(value))
            else:
                lines.append("")

        try:
            with open(output_path, 'w') as f:
                f.write('\n'.join(lines))
            print(f"文件已成功生成在: {output_path}")
        except IOError as e:
            print(f"写入文件时出错: {e}")

    def write_weather_header_from_dict(self, header_data: dict):
        """
        根据一个结构化的 Python 字典，生成原始的四行天气文件头。

        参数:
        header_data (dict): 包含所有头信息的字典。
        output_path (str): 输出文件的路径。
        """
        lines = []

        line1 = (f"{header_data.get('timestep', '')}"
                 f"{header_data.get('calendar', '')}"
                 f"{header_data.get('num_time_var', '')}"
                 f"{header_data.get('num_climate', '')}"
                 f"{header_data.get('time_format', '')}"
                 f"{header_data.get('variables', '')}")
        lines.append(line1)

        line2 = header_data.get('variable_units', '')
        lines.append(line2)

        global_params = header_data.get('global_parameters', {})
        line3_values = [
            global_params.get('windspeed_measurement_height', 0.0),
            global_params.get('flag_for_z0g_with_vegetation', 0.0),
            global_params.get('time_of_solar_noon', 0.0)
        ]
        lines.append(','.join(map(str, line3_values)))

        precip_chem = header_data.get('precipitation_chemistry', {})
        line4_values = [
            precip_chem.get('pH', 0.0),
            precip_chem.get('NH4_concentration', 0.0),
            precip_chem.get('NO3_concentration', 0.0),
            precip_chem.get('H2PO4_concentration', 0.0),
            precip_chem.get('Al_concentration', 0.0),
            precip_chem.get('Fe_concentration', 0.0),
            precip_chem.get('Ca_concentration', 0.0),
            precip_chem.get('Mg_concentration', 0.0),
            precip_chem.get('Na_concentration', 0.0),
            precip_chem.get('K_concentration', 0.0),
            precip_chem.get('SO4_concentration', 0.0),
            precip_chem.get('Cl_concentration', 0.0),
            precip_chem.get('undefined_parameter', 0.0)
        ]
        lines.append(','.join(map(str, line4_values)))

        print('WARNING: 注意：这里我们仅出头部，实际天气数据需要另外追加')
        for i in [0, 1, 2, 3]:
            print(lines[i])

#         try:
#             with open(output_path, 'w') as f:
#                 # 注意：这里我们仅写入头部，实际天气数据需要另外追加
#                 f.write('\n'.join(lines) + '\n')
#             print(f"天气文件头已成功生成在: {output_path}")
#         except IOError as e:
#             print(f"写入文件时出错: {e}")
