classdef SignLoader < handle
    properties
        DataDirectory
        AnnotationDirectory
        Signers
        Types
        CurrentVideo
        CurrentVideoPath
    end

    methods
        function obj = SignLoader(dataDir, annotationDir, signers)
            obj.DataDirectory = dataDir;
            obj.AnnotationDirectory = annotationDir;
            obj.Signers = signers;
            obj.Types = {'.vid', '.vimseq3'};
        end

        function [vid, meta, annotations] = loadSign(obj, index)
            % Extract the meta annotations
            % TODO: Random signer may not be OK for comparing all. It may skip
            % certain signer/sign combinations.
            signerIdx = randi(length(obj.Signers));
            metaFile = strcat('annotation_', obj.Signers(signerIdx), '.mat');
            fullPath = strcat(obj.AnnotationDirectory, metaFile);
            data = load(fullPath{1});
            data = data.data;

            % Collect metadata for file
            signName = data.lexicon{index};
            fileName = data.filename{index};
            startFrame = data.startframe(index);
            endFrame = data.endframe(index);
            filePath = [obj.DataDirectory, data.directory{index}, '/', fileName];
            meta = struct('SignName', signName, 'FileName', fileName, ...
                'Directory', data.directory{index}, 'StartFrame', startFrame, ...
                'EndFrame', endFrame);

            % Determine if the file is supported
            [~, ~, ext] = fileparts(filePath);
            assert(ismember(ext, obj.Types), 'SignLoader.loadSign: Unsupported file type.');

            % Extract the annotations
            handfaceFile = strcat('handface_manual_', obj.Signers(signerIdx), '.mat');
            handfacePath = strcat(obj.AnnotationDirectory, handfaceFile);
            handfaceData = load(handfacePath{1});
            annotations = handfaceData.handface(index, :);

            % Load the video using a specific video loader
            % TODO: Only supporting .vid for now
            if strcmp(obj.CurrentVideoPath, filePath) == 1
                vid = obj.CurrentVideo;
            else
                [vid, vidInfo] = vidOpenMex(filePath);
                obj.CurrentVideo = vid;
                obj.CurrentVideoPath = filePath;
            end
        end
    end
end
