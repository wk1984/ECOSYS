import re
import os

def cdl_to_pft_dict(cdl_content: str, pft_name_to_extract: str) -> dict:
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

def write_crop_params_from_config(config_data: dict, output_path: str):
    """
    根据配置字典生成一个作物/植被参数格式的文件。
    (此函数与之前版本相同)
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
            if isinstance(v, float) and v != 0.0 and (abs(v) < 1e-4 or abs(v) > 1e4):
                formatted_values.append(f"{v:.1E}".replace("E-0", "E-").replace("E+0", "E+"))
            else:
                formatted_values.append(str(v))
        lines.append(' '.join(formatted_values))

    try:
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write('\n'.join(lines))
        print(f"参数文件已成功生成在: {output_path}")
    except IOError as e:
        print(f"写入文件时出错: {e}")

# --- 新增的主函数 ---
def process_cdl_file(cdl_filepath: str, pft_name_to_extract: str, output_dir: str = '.'):
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
    full_config = cdl_to_pft_dict(cdl_content, pft_name_to_extract)

    # 3. 检查解析结果并调用写入函数
    if "error" in full_config:
        print(f"解析CDL时出错: {full_config['error']}")
    else:
        pft_data_to_write = full_config.get(pft_name_to_extract)
        if pft_data_to_write:
            # 确保输出目录存在
            os.makedirs(output_dir, exist_ok=True)
            
            # 定义输出文件的路径
            output_filepath = os.path.join(output_dir, f"{pft_name_to_extract}")
            
            # 调用写入函数
            write_crop_params_from_config(pft_data_to_write, output_filepath)
        else:
            print(f"错误：在解析后的数据中未能找到PFT '{pft_name_to_extract}' 的数据。")


# --- 主程序入口 ---
if __name__ == "__main__":
    # --- 配置区 ---
    # 1. 设置您的CDL文件路径
    INPUT_CDL_FILE = "ecosim_pft_20240314.nc.cdl" 
    
    # 2. 设置您想要生成参数文件的PFT列表
    PFTs_TO_PROCESS = ['gr3s32', 'gr3s35', 'bush31', 'sedg62', 'maiz31', 'lich33', 'jpin43', 'gr3s61', 'shru35', 'brom43', 'lich32', 'alfa43', 'gr3s33', 'busn32', 'clvs35', 'lich61', 'bdlf11', 'gr3a35', 'ndlf43', 'soyb31', 'clva35', 'tasp43', 'bdlf43', 'gr3a34', 'bdlf61', 'ndlf33', 'ndlf34', 'bdlf32', 'ndlf61', 'oats43', 'bdlf33', 'ndlf35', 'ndlf32', 'busn26', 'busn43', 'bspr62', 'gr3s43', 'moss62', 'gr3s26', 'moss43', 'gr3s62', 'bush32', 'gr4s26', 'sedg61', 'smos61', 'busn31', 'lich62', 'bspr43', 'dfir32', 'maiz33', 'lpin31', 'ndld43', 'bdlw62', 'swhe33', 'soyb33', 'bdln43', 'bdlf31', 'bdln32', 'barl43', 'bdlf62', 'swhe43', 'ndlf31', 'ndlf62', 'bush11', 'moss33', 'bush26', 'woak31', 'moss32', 'bush43', 'mosf43', 'moss61', 'fmos43'] 
    
    # 3. 设置输出目录
    OUTPUT_DIRECTORY = "pft_parameter_files"

    # --- 执行区 ---
    # 检查输入文件是否存在
    if not os.path.exists(INPUT_CDL_FILE):
        print(f"致命错误: 输入文件 '{INPUT_CDL_FILE}' 不存在。")
        print("请确保CDL文件与脚本位于同一目录，或提供完整路径。")
    else:
        # 循环处理所有指定的PFT
        for pft in PFTs_TO_PROCESS:
            process_cdl_file(
                cdl_filepath=INPUT_CDL_FILE, 
                pft_name_to_extract=pft, 
                output_dir=OUTPUT_DIRECTORY
            )