package common;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.os.Environment;
import android.support.annotation.NonNull;
import android.view.View;

import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

import androlua.LuaManager;

import static android.graphics.Bitmap.CompressFormat.JPEG;
import static android.graphics.Bitmap.CompressFormat.PNG;

/**
 * LuaFileUtils
 * Created by hanks on 16/6/28.
 */
public class LuaFileUtils {

    private static final String APP_DIR = "LLLLLua";

    private static Context getContext() {
        return LuaManager.getInstance().getContext();
    }

    public static File convertViewToImage(View view, @NonNull String filePath) throws Exception {
        if (view.getWidth() == 0 || view.getHeight() == 0) {
            throw new Exception("width or height must not be 0");
        }

        if (view.getHeight() > 100000) {
            throw new Exception("must small");
        }

        final File saveFile = new File(filePath);
        Bitmap createBitmap = Bitmap.createBitmap(view.getWidth(), view.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(createBitmap);
        canvas.save();
        view.draw(canvas);
        canvas.restore();
        String imageType = createBitmap.getHeight() > 20000 ? "jpg" : "png";
        Bitmap.CompressFormat compressFormat = "jpg".equals(imageType) ? PNG : JPEG;
        bitmapToFile(createBitmap, saveFile, compressFormat, "jpg".equals(imageType) ? 90 : 100);
        if (createBitmap != null) {
            createBitmap.recycle();
        }
        canvas.setBitmap(null);
        System.gc();
        return saveFile;
    }

    private static File bitmapToFile(Bitmap bitmap, File file, Bitmap.CompressFormat compressFormat, int quality) {
        if (file == null) {
            return null;
        }
        FileOutputStream fileOutputStream = null;
        try {
            fileOutputStream = new FileOutputStream(file);
            bitmap.compress(compressFormat, quality, fileOutputStream);
            fileOutputStream.flush();
            fileOutputStream.close();
            return file;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            try {
                if (fileOutputStream != null) fileOutputStream.close();
            } catch (IOException e22) {
                e22.printStackTrace();
            }
        }
    }

    public static String saveImage(String imagePath) {
        File file = new File(imagePath);
        if (!file.exists()) {
            return null;
        }
        try {
            String fileName = System.currentTimeMillis() + ".png";
            String outputPath = getProjectImagePath();
            //create output directory if it doesn't exist
            File dir = new File(outputPath);
            if (!dir.exists()) {
                dir.mkdirs();
            }
            InputStream in = new FileInputStream(imagePath);
            OutputStream out = new FileOutputStream(outputPath + "/" + fileName);
            byte[] buffer = new byte[1024];
            int read;
            while ((read = in.read(buffer)) != -1) {
                out.write(buffer, 0, read);
            }
            in.close();
            // write the output file (You have now copied the file)
            out.flush();
            out.close();
            return fileName;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String getImagePath(String name) {
        return getProjectImagePath() + "/" + name;
    }

    public static String getPublicPicturePath(String fileName) {
        // Get the directory for the user's public pictures directory.
        File file = new File(Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_PICTURES), APP_DIR);
        if (!file.mkdirs()) {
            LuaLog.e("Directory not created");
        }
        return file.getAbsolutePath() + "/" + fileName;
    }

    public static Bitmap getBitmapFromFile(String name) {
        String filePath = getProjectImagePath() + "/" + name;
        return BitmapFactory.decodeFile(filePath);
    }

    public static void makeDefaultCSSFile() {
        String path = getProjectCSSPath() + "/marked.css";
        File file = new File(path);
        if (!file.exists()) {
            makeDefaultCSSFile(path);
        }
    }

    private static void makeDefaultCSSFile(String path) {
        try {
            InputStream inputStream = getContext().getResources().getAssets().open("marked.css");
            saveToFile(inputStream, path);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static String convertStreamToString(InputStream is) {
        BufferedReader br = null;
        StringBuilder sb = new StringBuilder();
        String line;
        try {
            br = new BufferedReader(new InputStreamReader(is));
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return sb.toString();
    }

    public static String getProjectCSSPath() {
        return insureDirExists(getProjectPath() + "/css");
    }

    public static String getBackupPath() {
        return insureDirExists(getProjectPath() + "/backup");
    }

    public static String getBackupNotePath() {
        return insureDirExists(getProjectPath() + "/notejson");
    }

    private static String insureDirExists(String dir) {
        File file = new File(dir);
        if (!file.exists()) {
            file.mkdirs();
        }
        return file.getAbsolutePath();
    }

    public static String getProjectImagePath() {
        String path = getProjectPath() + "/images";
        insureDirExists(path);
        File noMediaFile = new File(path, ".nomedia");
        if (!noMediaFile.exists()) {
            try {
                noMediaFile.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return path;
    }

    public static String getProjectPath() {
        String downloadDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).getAbsolutePath();
        String filePath = new File(downloadDir).getParentFile().getAbsolutePath() + "/" + APP_DIR;
        File file = new File(filePath);
        if (!file.exists()) {
            file.mkdirs();
        }
        return filePath;
    }

    public static boolean sdCardAvaible() {
        return Environment.MEDIA_MOUNTED.equals(Environment.getExternalStorageState());
    }


    public static String saveToFile(InputStream in, String filePath) {
        try {
            FileOutputStream out = new FileOutputStream(filePath);
            byte[] buffer = new byte[1024];
            int read;
            while ((read = in.read(buffer)) != -1) {
                out.write(buffer, 0, read);
            }
            in.close();
            out.flush();
            out.close();
            return filePath;
        } catch (Exception e) {
            e.printStackTrace();
            return filePath;
        }
    }

    public static String saveToFile(String txt, String filePath) {
        try {
            File file = new File(filePath);
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
            FileWriter fooWriter = new FileWriter(file, false); // true to append // false to overwrite.
            fooWriter.write(txt);
            fooWriter.close();
            return file.getAbsolutePath();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return txt;
    }

    public static String getFontPath(String fontAlias) {
        String path = getProjectPath() + File.separator + "font";
        File dir = new File(path);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        return (dir + File.separator + fontAlias).toLowerCase();
    }

    /**
     * Extracts a zip file specified by the zipFilePath to a directory specified by
     * destDirectory (will be created if does not exists)
     *
     * @param zipFilePath
     * @param destDirectory
     * @throws IOException
     */
    public static void unzip(String zipFilePath, String destDirectory) throws IOException {
        File destDir = new File(destDirectory);
        if (!destDir.exists()) {
            destDir.mkdir();
        }
        ZipInputStream zipIn = new ZipInputStream(new FileInputStream(zipFilePath));
        ZipEntry entry = zipIn.getNextEntry();
        // iterates over entries in the zip file
        while (entry != null) {
            String filePath = (destDirectory + File.separator + entry.getName()).toLowerCase();
            if (!entry.isDirectory()) {
                // if the entry is a file, extracts it
                extractFile(zipIn, filePath);
            } else {
                // if the entry is a directory, make the directory
                File dir = new File(filePath);
                dir.mkdir();
            }
            zipIn.closeEntry();
            entry = zipIn.getNextEntry();
        }
        zipIn.close();
    }

    /**
     * Extracts a zip entry (file entry)
     *
     * @param zipIn
     * @param filePath
     * @throws IOException
     */
    private static void extractFile(ZipInputStream zipIn, String filePath) throws IOException {
        BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(filePath));
        byte[] bytesIn = new byte[2048];
        int read = 0;
        while ((read = zipIn.read(bytesIn)) != -1) {
            bos.write(bytesIn, 0, read);
        }
        bos.close();
    }

    public static void rewriteFile(File file, String content) {
        BufferedWriter bw = null;
        FileWriter fw = null;

        try {
            fw = new FileWriter(file);
            bw = new BufferedWriter(fw);
            bw.write(content);
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (bw != null)
                    bw.close();
                if (fw != null)
                    fw.close();
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }

    public static String getFileContent(File file) {
        BufferedReader br = null;
        try {
            br = new BufferedReader(new FileReader(file));
            StringBuilder sb = new StringBuilder();
            String line = br.readLine();

            while (line != null) {
                sb.append(line);
                sb.append("\n");
                line = br.readLine();
            }
            return sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (br != null) br.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    public static void deleteFile(String path) {
        File file = new File(path);
        if (file.exists()) {
            file.delete();
        }
    }

    public static void deleteDir(String dirPath) {
        File dir = new File(dirPath);
        if (!dir.exists()) {
            return;
        }
        if (dir.isDirectory()) {
            if (dir.listFiles() == null) {
                dir.delete();
                return;
            }
            for (File file : dir.listFiles()) {
                deleteDir(file.getAbsolutePath());
            }
        } else {
            dir.delete();
        }
    }

    public static void writeZip(File file, String parentPath, ZipOutputStream zos) {
        if (file.exists()) {
            if (file.isDirectory()) {//处理文件夹
                parentPath += file.getName() + File.separator;
                File[] files = file.listFiles();
                if (files == null) {
                    return;
                }
                for (File f : files) {
                    writeZip(f, parentPath, zos);
                }
            } else {
                FileInputStream fis = null;
                try {
                    fis = new FileInputStream(file);
                    ZipEntry ze = new ZipEntry(parentPath + file.getName());
                    zos.putNextEntry(ze);
                    byte[] content = new byte[1024];
                    int len;
                    while ((len = fis.read(content)) != -1) {
                        zos.write(content, 0, len);
                        zos.flush();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try {
                        if (fis != null) {
                            fis.close();
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }

    public static String getAndroLuaDir() {
        File appDir;
        if (sdCardAvaible()) {
            appDir = getContext().getExternalFilesDir(APP_DIR);
        }else {
            appDir = new File(getContext().getFilesDir(), APP_DIR);
        }
        appDir.mkdirs(); // dont need judge dir exits

        return appDir.getAbsolutePath();
    }

    public static byte[] readAsset(String name) throws IOException {
        AssetManager am = getContext().getAssets();
        InputStream is = am.open(name);
        byte[] ret = readAll(is);
        is.close();
        //am.close();
        return ret;
    }

    private static byte[] readAll(InputStream input) throws IOException {
        ByteArrayOutputStream output = new ByteArrayOutputStream(4096);
        byte[] buffer = new byte[4096];
        int n = 0;
        while (-1 != (n = input.read(buffer))) {
            output.write(buffer, 0, n);
        }
        byte[] ret = output.toByteArray();
        output.close();
        return ret;
    }

    //复制asset文件到sd卡
    public void assetsToSD(String InFileName, String OutFileName) throws IOException {
        InputStream myInput;
        OutputStream myOutput = new FileOutputStream(OutFileName);
        myInput = getContext().getAssets().open(InFileName);
        byte[] buffer = new byte[8192];
        int length = myInput.read(buffer);
        while (length > 0) {
            myOutput.write(buffer, 0, length);
            length = myInput.read(buffer);
        }

        myOutput.flush();
        myInput.close();
        myOutput.close();
    }

    /**
     * 解压Assets中的文件
     */
    public void unZipAssets(String assetName, String outputDirectory) throws IOException {
        //创建解压目标目录
        File file = new File(outputDirectory);
        //如果目标目录不存在，则创建
        if (!file.exists()) {
            file.mkdirs();
        }
        InputStream inputStream = null;
        //打开压缩文件
        try {
            inputStream = getContext().getAssets().open(assetName);
        } catch (IOException e) {
            return;
        }

        ZipInputStream zipInputStream = new ZipInputStream(inputStream);
        //读取一个进入点
        ZipEntry zipEntry = zipInputStream.getNextEntry();
        //使用1Mbuffer
        byte[] buffer = new byte[1024 * 32];
        //解压时字节计数
        int count = 0;
        //如果进入点为空说明已经遍历完所有压缩包中文件和目录
        while (zipEntry != null) {
            //如果是一个目录
            if (zipEntry.isDirectory()) {
                //String name = zipEntry.getName();
                //name = name.substring(0, name.length() - 1);
                file = new File(outputDirectory + File.separator + zipEntry.getName());
                file.mkdir();
            } else {
                //如果是文件
                file = new File(outputDirectory + File.separator
                        + zipEntry.getName());
                //创建该文件
                file.createNewFile();
                FileOutputStream fileOutputStream = new FileOutputStream(file);
                while ((count = zipInputStream.read(buffer)) > 0) {
                    fileOutputStream.write(buffer, 0, count);
                }
                fileOutputStream.close();
            }
            //定位到下一个文件入口
            zipEntry = zipInputStream.getNextEntry();
        }
        zipInputStream.close();
    }
}
