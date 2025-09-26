% ########## ここからコピー ##########

% BCI Competition IV dataset 2b のための完全な前処理スクリプト
% GDF(信号)とMAT(ラベル)の両ファイルを読み込んで処理します。

% --- 被験者ループの開始 ---
for subject_index = 1:9
    
    fprintf('Processing Subject B0%d...\n', subject_index);

    % --- セッションループの開始 ---
    % セッション 1, 2, 3 は訓練(T)、4, 5 は評価(E)
    for session_index = 1:5

        if session_index <= 3
            session_type = 'T';
        else
            session_type = 'E';
        end
        
        fprintf('  Processing session %d%s...\n', session_index, session_type);

        % GDFデータファイル(信号)のパスを動的に生成
        gdf_path = sprintf('/home/kawamura/BCI2020/EEG-Conformer/Data/BCI_IV_2b/B0%d0%d%s.gdf', subject_index, session_index, session_type);
        [s, HDR] = sload(gdf_path);

        % MATファイル(ラベル)のパスを動的に生成
        label_path = sprintf('/home/kawamura/BCI2020/EEG-Conformer/Data/BCI_IV_2b/B0%d0%d%s.mat', subject_index, session_index, session_type);
        
        if isfile(label_path)
            label_struct = load(label_path);
            % .matファイル内の変数名を特定する必要があるが、多くの場合'classlabel'
            % もしエラーが出たら、ここを 'true_y' などに変更する必要があるかもしれない
            if isfield(label_struct, 'classlabel')
                label = label_struct.classlabel;
            else
                % もし 'classlabel' がなければ、ファイル内の最初の変数をラベルと仮定
                fields = fieldnames(label_struct);
                label = label_struct.(fields{1});
            end
        else
            warning('Label file not found: %s. Cannot proceed.', label_path);
            continue; % ラベルファイルがなければこのセッションはスキップ
        end
        
        % イベント情報を使って試行を切り出す
        Pos = HDR.EVENT.POS;
        Typ = HDR.EVENT.TYP;
        
        trial_indices = find(Typ == 768); % 試行開始マーカー
        num_trials = length(trial_indices);
        
        % ラベルの数と試行マーカーの数が一致するか確認
        if num_trials ~= length(label)
            warning('Mismatch between number of trials (%d) and labels (%d) for B0%d0%d%s.', num_trials, length(label), subject_index, session_index, session_type);
        end
        
        data = zeros(1000, 3, num_trials);
        for k = 1:num_trials
            start_pos = Pos(trial_indices(k));
            data(:,:,k) = s((start_pos+750):(start_pos+1749), 1:3);
        end
        data(isnan(data)) = 0; % NaN値を0で置換
        
        % フィルタリング
        fc = 250;
        Wl = 4; Wh = 40;
        Wn = [Wl*2 Wh*2]/fc;
        [b, a] = cheby2(6, 60, Wn);
        for j = 1:size(data, 3)
            data(:,:,j) = filtfilt(b, a, data(:,:,j));
        end

        % 処理済みの信号データとラベルを、同じ名前の.matファイルとして上書き保存
        saveDir = sprintf('/home/kawamura/BCI2020/EEG-Conformer/Data/BCI_IV_2b/B0%d0%d%s.mat', subject_index, session_index, session_type);
        save(saveDir, 'data', 'label');
        fprintf('  Saved processed data to %s\n', saveDir);

    end % --- セッションループの終了 ---
    fprintf('\n');
end % --- 被験者ループの終了 ---

disp('All subjects and sessions processed successfully!');

% ########## ここまでコピー ##########