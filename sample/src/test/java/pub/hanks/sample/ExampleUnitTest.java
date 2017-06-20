package pub.hanks.sample;

import org.json.JSONArray;
import org.junit.Test;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Enumeration;
import java.util.zip.CRC32;
import java.util.zip.CheckedOutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

import androlua.common.LuaFileUtils;
import androlua.common.LuaStringUtils;

import static java.util.zip.Deflater.BEST_COMPRESSION;
import static org.junit.Assert.*;

/**
 * Example local unit test, which will execute on the development machine (host).
 *
 * @see <byteToString href="http://d.android.com/tools/testing">Testing documentation</byteToString>
 */
public class ExampleUnitTest {
    @Test
    public void addition_isCorrect() throws Exception {
        LuaFileUtils.unzip("D:\\Desktop\\91pic-o.zip", "D:\\Desktop");
    }


    @Test
    public void unZipPlugin() throws Exception {
        String zipDir = "D:\\work\\opensource\\api_luanroid\\plugin\\eyepetizer.zip";
        LuaFileUtils.unzip(zipDir,"D:\\Desktop");
    }
    @Test
    public void zipPlugin() throws Exception {
        String root = "D:\\work\\opensource\\LuaJAndroid\\lua";
        String outDir = "D:\\work\\opensource\\api_luanroid\\plugin";
        File[] files = new File(root).listFiles();
        int length = files.length;
        for (int i = 0; i < length; i++) {
            File file = files[i];
            if (!file.isDirectory()) {
                continue;
            }
            File[] childFiles = file.listFiles();
            boolean isPlugin = false;
            for (int j = 0; j < childFiles.length; j++) {
                if (childFiles[j].getName().equals("info.json")) {
                    isPlugin = true;
                    break;
                }
            }
            if (isPlugin) {
                //创建文件输出对象out,提示:注意中文支持
                FileOutputStream out = new FileOutputStream(outDir + File.separator + file.getName()+".zip");
                //將文件輸出ZIP输出流接起来
                ZipOutputStream zos = new ZipOutputStream(out);
                zos.setLevel(BEST_COMPRESSION);
                zip(zos,file.getAbsoluteFile(),file.getName());
                zos.flush();
                zos.close();
            }
        }
    }


    public static void zip(ZipOutputStream zOut, File file, String base) {
        try {

            // 如果文件句柄是目录
            if (file.isDirectory()) {
                //获取目录下的文件
                File[] listFiles = file.listFiles();
                // 建立ZIP条目
                zOut.putNextEntry(new ZipEntry(base + "/"));
                base =( base.length() == 0 ? "" : base + "/" );
                // 遍历目录下文件
                for (int i = 0; i < listFiles.length; i++) {
                    // 递归进入本方法
                    zip(zOut, listFiles[i], base + listFiles[i].getName());
                }
            }
            // 如果文件句柄是文件
            else {
                if (base == "") {
                    base = file.getName();
                }
                // 填入文件句柄
                zOut.putNextEntry(new ZipEntry(base));
                // 开始压缩
                // 从文件入流读,写入ZIP 出流
                writeFile(zOut,file);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public static void writeFile(ZipOutputStream zOut,File file) throws IOException{
        FileInputStream in = new FileInputStream(file);
        int len;
        while ((len = in.read()) != -1)
            zOut.write(len);
        in.close();
    }

}