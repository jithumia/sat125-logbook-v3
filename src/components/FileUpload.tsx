import React, { useRef, useState } from 'react';
import { Paperclip, X } from 'lucide-react';
import toast from 'react-hot-toast';

interface FileUploadProps {
  files: File[];
  onFilesChange: (files: File[]) => void;
}

const FileUpload: React.FC<FileUploadProps> = ({ files, onFilesChange }) => {
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [isDragging, setIsDragging] = useState(false);

  const validateFile = (file: File): boolean => {
      // Check file type
      const validTypes = [
        'image/jpeg', 
        'image/png', 
        'image/gif', 
        'video/mp4', 
        'video/quicktime',
        'text/plain',
        'text/csv',
        'text/x-log',
        'application/json',
        'application/xml'
      ];
      if (!validTypes.includes(file.type)) {
        toast.error(`Invalid file type: ${file.name}. Supported types: Images, Videos, Text files, Logs, CSV, JSON, XML`);
        return false;
      }
      
      // Check file size (50MB limit)
      const maxSize = 50 * 1024 * 1024; // 50MB in bytes
      if (file.size > maxSize) {
        toast.error(`File too large: ${file.name}. Maximum size is 50MB`);
        return false;
      }
      
      return true;
  };

  const handleFiles = (newFiles: FileList | null) => {
    if (!newFiles) return;

    const selectedFiles = Array.from(newFiles);
    const validFiles = selectedFiles.filter(validateFile);

    if (validFiles.length > 0) {
    onFilesChange([...files, ...validFiles]);
    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
    }
  };

  const handleDragOver = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(true);
  };

  const handleDragLeave = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);
  };

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);
    handleFiles(e.dataTransfer.files);
  };

  const removeFile = (index: number) => {
    const newFiles = [...files];
    newFiles.splice(index, 1);
    onFilesChange(newFiles);
  };

  const formatFileSize = (bytes: number): string => {
    if (bytes === 0) return '0 B';
    const k = 1024;
    const sizes = ['B', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return `${parseFloat((bytes / Math.pow(k, i)).toFixed(1))} ${sizes[i]}`;
  };

  return (
    <div className="space-y-4">
      <div
        className={`border-2 border-dashed rounded-lg p-4 transition-colors ${
          isDragging
            ? 'border-indigo-500 bg-indigo-500/10'
            : 'border-gray-700 hover:border-gray-600'
        }`}
        onDragOver={handleDragOver}
        onDragLeave={handleDragLeave}
        onDrop={handleDrop}
      >
        <div className="flex flex-col items-center justify-center space-y-2">
        <button
          type="button"
          onClick={() => fileInputRef.current?.click()}
          className="flex items-center space-x-2 px-4 py-2 bg-gray-700 text-white rounded-md hover:bg-gray-600 transition-colors"
        >
          <Paperclip className="h-4 w-4" />
            <span>Choose Files</span>
        </button>
        <input
          ref={fileInputRef}
          type="file"
          multiple
          accept="image/jpeg,image/png,image/gif,video/mp4,video/quicktime,text/plain,text/csv,text/x-log,application/json,application/xml"
          onChange={(e) => handleFiles(e.target.files)}
          className="hidden"
        />
          <p className="text-sm text-gray-400">
            or drag and drop files here
          </p>
          <p className="text-xs text-gray-500">
          Max 50MB per file. Supported: Images, Videos, Text files, Logs, CSV, JSON, XML
          </p>
        </div>
      </div>

      {files.length > 0 && (
        <div className="space-y-2">
          {files.map((file, index) => (
            <div
              key={index}
              className="flex items-center justify-between bg-gray-700/50 rounded-lg p-2"
            >
              <div className="flex items-center space-x-2">
                <Paperclip className="h-4 w-4 text-gray-400" />
                <span className="text-sm text-gray-200">{file.name}</span>
                <span className="text-xs text-gray-400">
                  ({formatFileSize(file.size)})
                </span>
              </div>
              <button
                type="button"
                onClick={() => removeFile(index)}
                className="text-gray-400 hover:text-white p-1 rounded-full hover:bg-white/10 transition-colors"
              >
                <X className="h-4 w-4" />
              </button>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

export default FileUpload;