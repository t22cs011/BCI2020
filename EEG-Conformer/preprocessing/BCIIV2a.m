% ########## ここからコピー ##########

% BCI Competition IV dataset 2a のための完全な前処理スクリプト
% 9人の被験者全員の訓練(T)および評価(E)データを処理します。

% --- ループの開始 ---
for subject_index = 1:9 % 1番から9番までの被験者をループ

    fprintf('Processing Subject %d...\n', subject_index);

    %% --- 訓練データ (T) の処理 ---
    session_type = 'T';
    
    % GDFデータファイルのパスを動的に生成
    gdf_path_T = sprintf('/home/kawamura/BCI2020/EEG-Conformer/Data/BCI_IV_2a/A0%dT.gdf', subject_index);
    [s_T, HDR_T] = sload(gdf_path_T);

    % 正解ラベルファイルのパスを動的に生成
    label_path_T = sprintf('/home/kawamura/BCI2020/EEG-Conformer/Data/BCI_IV_2a/A0%dE.mat', subject_index); % 正しいラベルファイル名を指定
    load(label_path_T); % 'classlabel' 変数が読み込まれる
    label_T = classlabel;

    % イベント情報を使って試行を切り出す
    Pos_T = HDR_T.EVENT.POS;
    Typ_T = HDR_T.EVENT.TYP;
    k = 0;
    data_T = zeros(1000, 22, length(label_T));
    for j = 1:length(Typ_T)
        if Typ_T(j) == 768 % 試行開始のマーカー
            k = k+1;
            data_T(:,:,k) = s_T((Pos_T(j)+500):(Pos_T(j)+1499), 1:22);
        end
    end
    data_T(isnan(data_T)) = 0; % NaN値を0で置換

    %% --- 評価データ (E) の処理 ---
    session_type = 'E';
    
    % GDFデータファイルのパスを動的に生成
    gdf_path_E = sprintf('/home/kawamura/BCI2020/EEG-Conformer/Data/BCI_IV_2a/A0%dE.gdf', subject_index);
    [s_E, HDR_E] = sload(gdf_path_E);

    % 正解ラベルファイルのパスを動的に生成
    label_path_E = sprintf('/home/kawamura/BCI2020/EEG-Conformer/Data/BCI_IV_2a/A0%dE.mat', subject_index); % 正しいラベルファイル名を指定
    load(label_path_E);
    label_E = classlabel;

    % イベント情報を使って試行を切り出す
    Pos_E = HDR_E.EVENT.POS;
    Typ_E = HDR_E.EVENT.TYP;
    k = 0;
    data_E = zeros(1000, 22, length(label_E));
    for j = 1:length(Typ_E)
        if Typ_E(j) == 768
            k = k+1;
            data_E(:,:,k) = s_E((Pos_E(j)+500):(Pos_E(j)+1499), 1:22);
        end
    end
    data_E(isnan(data_E)) = 0;

    %% --- 前処理 (フィルタリング) ---
    fc = 250; % サンプリングレート
    Wl = 4; Wh = 40; % 通過帯域
    Wn = [Wl*2 Wh*2]/fc;
    [b, a] = cheby2(6, 60, Wn);
    
    for j = 1:size(data_T, 3)
        data_T(:,:,j) = filtfilt(b, a, data_T(:,:,j));
    end
    for j = 1:size(data_E, 3)
        data_E(:,:,j) = filtfilt(b, a, data_E(:,:,j));
    end

    %% --- データを.matファイルとして保存 ---
    
    % 訓練データの保存
    data = data_T;
    label = label_T;
    saveDir_T = sprintf('/home/kawamura/BCI2020/EEG-Conformer/Data/BCI_IV_2a/A0%dT.mat', subject_index);
    save(saveDir_T, 'data', 'label');
    fprintf('Saved %s\n', saveDir_T);

    % 評価データの保存
    data = data_E;
    label = label_E;
    saveDir_E = sprintf('/home/kawamura/BCI2020/EEG-Conformer/Data/BCI_IV_2a/A0%dE.mat', subject_index);
    save(saveDir_E, 'data', 'label');
    fprintf('Saved %s\n\n', saveDir_E);

end % --- ループの終了 ---

disp('All subjects processed successfully!');

% ########## ここまでコピー ##########
