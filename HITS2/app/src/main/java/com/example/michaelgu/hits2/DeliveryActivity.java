package com.example.michaelgu.hits2;

import android.app.Activity;
import android.app.DownloadManager;
import android.content.Intent;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Environment;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.support.v7.app.ActionBarDrawerToggle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.Toast;

import com.microsoft.onedrivesdk.*;
import com.microsoft.onedrivesdk.picker.IPicker;
import com.microsoft.onedrivesdk.picker.IPickerResult;
import com.microsoft.onedrivesdk.picker.LinkType;
import com.microsoft.onedrivesdk.picker.Picker;
import com.microsoft.onedrivesdk.saver.ISaver;
import com.microsoft.onedrivesdk.saver.Saver;
import com.microsoft.onedrivesdk.saver.SaverException;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.util.Calendar;


public class DeliveryActivity extends ActionBarActivity {

    //fields for navigation drawer
    private ListView mDrawerList;
    private ArrayAdapter<String> mAdapter;
    private ActionBarDrawerToggle mDrawerToggle;
    private DrawerLayout mDrawerLayout;
    private String mActivityTitle;

    //fields used by OneDrive SDK
    private IPicker mPicker;
    private ISaver mSaver;
    private Uri mDownloadUrl;
    private File savedFileDirectory;
    private static final String ONEDRIVE_APP_ID = "48122D4E";


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_delivery);

        //setup OneDrive SDK Picker and Saver
        mPicker = Picker.createPicker(ONEDRIVE_APP_ID);
        mSaver = Saver.createSaver(ONEDRIVE_APP_ID);
        findViewById(R.id.launchButton).setOnClickListener(mStartPickingListener);
        findViewById(R.id.saveButton).setOnClickListener(mScreenShotListener);

        //configure ListView for Side Navigation Drawer
        configureNavDrawer();

        //set webview as temporarily invisible until URL is available
        WebView pdfWebView = (WebView)findViewById(R.id.pdfWebView);
        pdfWebView.setVisibility(View.INVISIBLE);
    }


    @Override
    protected void onActivityResult(final int requestCode, final int resultCode, final Intent data) {
        if(requestCode == mSaver.getRequestCode()) {
            try {
                mSaver.handleSave(requestCode, resultCode, data);
                EditText emailText = (EditText) findViewById(R.id.editEmail);
                sendMail(savedFileDirectory.toString(), emailText.getText().toString());

            } catch (final SaverException e) {
            }

        }else if(requestCode == mPicker.getRequestCode()){
            // Get the results from the from the picker
            final IPickerResult result = mPicker.getPickerResult(requestCode, resultCode, data);
            mDownloadUrl = result.getLink();
            displayWebView();
        }
    }

    private void displayWebView(){
        if (mDownloadUrl == null) {
            return;
        }

        WebView pdfWebView = (WebView)findViewById(R.id.pdfWebView);
        pdfWebView.setVisibility(View.VISIBLE);
        pdfWebView.getSettings().setJavaScriptEnabled(true);
        pdfWebView.setWebViewClient(new Callback());
        pdfWebView.loadUrl("http://docs.google.com/gview?embedded=true&url=" + mDownloadUrl.toString().replace("?download&psid=1", ""));
    }

    private class Callback extends WebViewClient {
        @Override
        public boolean shouldOverrideUrlLoading(
                WebView view, String url) {
            return(false);
        }
    }

    //<------------------------OnClickListeners--------------------------------------->

    private final View.OnClickListener mStartPickingListener = new View.OnClickListener() {
        @Override
        public void onClick(final View v) {
            // Start the picker
            mPicker.startPicking((Activity) v.getContext(), LinkType.DownloadLink);
        }
    };

    public final View.OnClickListener mScreenShotListener = new View.OnClickListener() {
        @Override
        public void onClick(View view) {

            //format month correctly for database
            Calendar mCalendar = Calendar.getInstance();
            String month = Integer.toString(mCalendar.get(Calendar.MONTH) +1);
            if(mCalendar.get(Calendar.MONTH) < 9){
                month = "0" + mCalendar.get(Calendar.MONTH);
            }

            //configure filename
            String fileName = ((EditText)findViewById(R.id.editPickupFrom)).getText().toString() + mCalendar.get(Calendar.YEAR) + month + mCalendar.get(Calendar.DATE);

            // path to /data/data/yourapp/app_data/imageDir
            File directory = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);

            //prep for screenshot
            View rootView = view.getRootView();
            Bitmap bitmap = Bitmap.createBitmap(rootView.getMeasuredWidth(), rootView.getMeasuredHeight(), Bitmap.Config.RGB_565);
            Canvas screenShotCanvas = new Canvas(bitmap);
            rootView.draw(screenShotCanvas);

            OutputStream os = null;
            savedFileDirectory = new File(directory, fileName);

            try {
                os = new FileOutputStream(savedFileDirectory);
                bitmap.compress(Bitmap.CompressFormat.JPEG, 100, os);
                os.flush();
                os.close();

            } catch(FileNotFoundException e){
                e.printStackTrace();

            }catch(IOException e){
                e.printStackTrace();
            }
            mSaver.startSaving((Activity)view.getContext(), fileName, Uri.fromFile(savedFileDirectory));
        }
    };


    //<------------------------Private Helper Methods--------------------------------------->

    private void sendMail(String path, String address) {
        Intent emailIntent = new Intent(android.content.Intent.ACTION_SEND);
        emailIntent.putExtra(android.content.Intent.EXTRA_EMAIL,
                new String[] { address });
        emailIntent.putExtra(android.content.Intent.EXTRA_SUBJECT,
                "HITS Scanning Solutions - Delivery Receipt");
        emailIntent.putExtra(android.content.Intent.EXTRA_TEXT,
                "This is an autogenerated delivery receipt from HITS Scanning Solutions. Thank you for choosing our services!");
        emailIntent.setType("image/jpg");
        Uri myUri = Uri.parse("file://" + path);
        emailIntent.putExtra(Intent.EXTRA_STREAM, myUri);
        startActivity(Intent.createChooser(emailIntent, "Send mail..."));
    }

    private  void configureNavDrawer(){
        mDrawerList = (ListView)findViewById(R.id.navList);
        mDrawerLayout = (DrawerLayout)findViewById(R.id.drawer_layout);
        mActivityTitle = getTitle().toString();
        setupDrawer();
        addDrawerItems();

        //obtain hamburger style nav icons
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setHomeButtonEnabled(true);

        mDrawerList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent pickupIntent = new Intent(DeliveryActivity.this, PickupActivity.class);
                startActivity(pickupIntent);
            }
        });
    }

    private void setupDrawer(){
        mDrawerToggle = new ActionBarDrawerToggle(this, mDrawerLayout,
                R.string.drawer_open, R.string.drawer_close) {

            /** Called when a drawer has settled in a completely open state. */
            public void onDrawerOpened(View drawerView) {
                super.onDrawerOpened(drawerView);
                getSupportActionBar().setTitle("Options");
                invalidateOptionsMenu(); // creates call to onPrepareOptionsMenu()
            }

            /** Called when a drawer has settled in a completely closed state. */
            public void onDrawerClosed(View view) {
                super.onDrawerClosed(view);
                getSupportActionBar().setTitle(mActivityTitle);
                invalidateOptionsMenu();
            }
        };
        mDrawerToggle.setDrawerIndicatorEnabled(true);
        mDrawerLayout.setDrawerListener(mDrawerToggle);
    }

    private void addDrawerItems() {
        String[] osArray = { "Pickup", "Delivery" };
        mAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, osArray);
        mDrawerList.setAdapter(mAdapter);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_delivery, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.

        if (mDrawerToggle.onOptionsItemSelected(item)) {
            return true;
        }

        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    protected void onPostCreate(Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        mDrawerToggle.syncState();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        mDrawerToggle.onConfigurationChanged(newConfig);
    }
}
