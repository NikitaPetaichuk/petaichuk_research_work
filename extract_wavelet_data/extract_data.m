src_dir_path = "txt\calm_days";
dst_dir_path = "extracted_data\calm_days";
txt_files = dir(src_dir_path);
txt_files(1:2) = [];
files_count = numel(txt_files);

for i = 1:files_count
    input_file_path = fullfile(src_dir_path, txt_files(i).name);
    file_data = readtable(input_file_path);
    signal = file_data{:,2};
    signal2 = padarray(signal, 5760, 'sym', 'both'); % если одномерный сигнал в переменной signal, то этой командой достраиваем в обе стороны его на 5760. 
    Fs = 0.016;                                      % частота дискретизации сигнала
    fc = centfrq('coif2');                           % центральная частота вейвлета, вызывается по имени вейвлет функции.
    freqrange = [0.000005 0.016];                    % рассматриваемые частоты как раз, первое самая низкая, вторая самая высокая
    scalerange = fc./(freqrange*(1/Fs));             % переводим верхнюю и нижнюю частоты в соотвествующие мастабы
    scales = scalerange(end):5:scalerange(1);        % число рассматриваемых масштабов, вместо 1 можно например 10 поставить чтобы быстрее считалось, это по сути шаг, рассматривать будет каждый 10 масштаб тогда
    Coeffs = cwt(signal2,scales,'coif2');            % на этом этапе как раз НВП делаем по заданным выше параметрам.
    Coeffs = Coeffs';                                % нам нужно отрезать то что добавили поэтому транспонируем 
    coefftest = Coeffs(5760:length(signal2)-5760,:); % отрезаем то что добавили с обоих сторон
    coefftest = coefftest';                          % транспонируем обратно
    image = coefftest;                               % получаем массив который уже можно спокойно строить без краевого эффекта.
    extracted_data = image(:,2877:4316);
    output_file_path = fullfile(dst_dir_path, txt_files(i).name);
    writematrix(extracted_data, output_file_path);
end