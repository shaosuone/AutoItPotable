// (c)2014 Telerik
// This sample code is provided "AS IS" with no warranties.
//
// Prototype content-blocker allows testing of websites when some resources are blocked.
//
using System;
using System.Collections;
using System.Globalization;
using System.Collections.Generic;
using System.Windows.Forms;
using System.Text;
using Fiddler;
using System.IO;
using System.Diagnostics;
using Microsoft.Win32;
using System.Reflection;

[assembly: Fiddler.RequiredVersion("2.4.9.0")]
[assembly: AssemblyVersion("2.4.9.0")]
[assembly: AssemblyTitle("ContentBlock")]
[assembly: AssemblyDescription("Block HTTP(S) Requests")]
[assembly: AssemblyProduct("ContentBlock")]

public class ContentBlocker : IAutoTamper, IHandleExecAction
{
    private HostList hlBlockedHosts;
    private bool bBlockerEnabled = false;
    string sSecret = new Random().Next().ToString();
    private System.Windows.Forms.MenuItem miBlockAHost;
    private System.Windows.Forms.MenuItem mnuContentBlock;
    private System.Windows.Forms.MenuItem miContentBlockEnabled;
    private System.Windows.Forms.MenuItem miEditBlockedHosts;
    private System.Windows.Forms.MenuItem miSplit1;
    private System.Windows.Forms.MenuItem miFlashAlwaysBlock;
    private System.Windows.Forms.MenuItem miBlockXDomainFlash;
    private System.Windows.Forms.MenuItem miLikelyPaths;
    private System.Windows.Forms.MenuItem miShortCircuitRedirects;
    private System.Windows.Forms.MenuItem miHideBlockedSessions;
    private System.Windows.Forms.MenuItem miSplit2;
    private System.Windows.Forms.MenuItem miSplit3;

    private void InitializeMenu()
    {
        miBlockAHost = new System.Windows.Forms.MenuItem();
        miEditBlockedHosts = new System.Windows.Forms.MenuItem();
        mnuContentBlock = new System.Windows.Forms.MenuItem();
        miContentBlockEnabled = new System.Windows.Forms.MenuItem();
        miSplit1 = new System.Windows.Forms.MenuItem();
        miFlashAlwaysBlock = new System.Windows.Forms.MenuItem();
        miBlockXDomainFlash = new System.Windows.Forms.MenuItem();
        miLikelyPaths = new System.Windows.Forms.MenuItem();
        miShortCircuitRedirects = new System.Windows.Forms.MenuItem();
        miHideBlockedSessions = new System.Windows.Forms.MenuItem();
        miSplit2 = new System.Windows.Forms.MenuItem();
        miSplit3 = new System.Windows.Forms.MenuItem();
        // 
        // mnuContentBlock
        // 
        mnuContentBlock.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
                                                                                        miContentBlockEnabled,
                                                                                        miSplit1,
                                                                                        miEditBlockedHosts,
                                                                                        miLikelyPaths,
                                                                                        miSplit2,
                                                                                        miFlashAlwaysBlock,
                                                                                        miBlockXDomainFlash,
                                                                                        miSplit3,
                                                                                        miShortCircuitRedirects,
                                                                                        miHideBlockedSessions,
                                                        });
        mnuContentBlock.Text = "&ContentBlock";

        // 
        // miContentBlockEnabled
        // 
        miContentBlockEnabled.Index = 0;
        miContentBlockEnabled.Text = "&Enabled";
        miContentBlockEnabled.Click += new System.EventHandler(miBlockRule_Click);
        // 
        // miSplit1
        // 
        miSplit1.Index = 1;
        miSplit1.Text = "-";
        // 
        // miLikelyPaths
        // 
        miLikelyPaths.Index = 2;
        miLikelyPaths.Enabled = false;
        miLikelyPaths.Text = "&Block Paths";
        miLikelyPaths.Click += new System.EventHandler(miBlockRule_Click);
        // 
        // miEditBlockedHosts
        // 
        miEditBlockedHosts.Index = 3;
        miEditBlockedHosts.Enabled = false;
        miEditBlockedHosts.Text = "Edit B&locked Hosts...";
        miEditBlockedHosts.Click += new System.EventHandler(miEditBlockedHosts_Click);
        // 
        // miSplit2
        // 
        miSplit2.Index = 4;
        miSplit2.Enabled = false;
        miSplit2.Text = "-";
        // 
        // miFlashAlwaysBlock
        // 
        miFlashAlwaysBlock.Index = 5;
        miFlashAlwaysBlock.Enabled = false;
        miFlashAlwaysBlock.Text = "Always Block &Flash";
        miFlashAlwaysBlock.Click += new System.EventHandler(miBlockRule_Click);
        // 
        // miBlockXDomainFlash
        // 
        miBlockXDomainFlash.Index = 6;
        miBlockXDomainFlash.Enabled = false;
        miBlockXDomainFlash.Text = "Block &X-Domain Flash";
        miBlockXDomainFlash.Click += new System.EventHandler(miBlockRule_Click);
        // 
        // miSplit3
        // 
        miSplit3.Index = 7;
        miSplit3.Text = "-";
        // 
        // miShortCircuitRedirects
        // 
        miShortCircuitRedirects.Index = 8;
        miShortCircuitRedirects.Enabled = false;
        miShortCircuitRedirects.Text = "Short-circuit &Redirects";
        miShortCircuitRedirects.Click += new System.EventHandler(miBlockRule_Click);
        // 
        // miHideBlockedSessions
        // 
        miHideBlockedSessions.Index = 9;
        miHideBlockedSessions.Enabled = false;
        miHideBlockedSessions.Text = "&Hide Blocked Sessions";
        miHideBlockedSessions.Click += new System.EventHandler(miBlockRule_Click);
        // 
        // miBlockAHost
        // 
        miBlockAHost.Text = "Block this Host";
        miBlockAHost.Click += new System.EventHandler(miBlockAHost_Click);
    }

    // Issue: Always returns True. Why?
    public bool BlockAHost(string sHost)
    {
        if (!hlBlockedHosts.ContainsHost(sHost))
        {
            string sNewList = String.Format("{0}; {1}", hlBlockedHosts, sHost);
            hlBlockedHosts = new HostList(sNewList);
        }
        return true;
    }

    private void miBlockAHost_Click(object sender, System.EventArgs e)
    {
        Session[] oSessions = FiddlerApplication.UI.GetSelectedSessions();

        // TODO: This pattern is a bit hacky, insofar as the HostList is reconstructed 
        // for every addition; we're not bulk-adding all of the hosts at once. But it's 
        // simpler this way, and this isn't a hot codepath.
        //
        // To optimize, get the current host list, add all of the new hosts, and call
        // AssignFromString on the list.
        //
        foreach (Session oSession in oSessions)
        {
            try
            {
                BlockAHost(oSession.host.ToLower());
            }
            catch (Exception eX)
            {
                MessageBox.Show(eX.Message, "Cannot block host");
            }
        }
    }

    /// <summary>
    /// Ensures a 1x1 Transparent GIF file is in the \Responses\ subfolder. 
    /// This image will be returned by Fiddler for certain blocked content.
    /// </summary>
    private void EnsureTransGif()
    {
        if (!File.Exists(CONFIG.GetPath("Responses") + "1pxtrans.dat"))
        {
            try
            {
                byte[] arrHeaders = Encoding.UTF8.GetBytes("HTTP/1.1 404 Blocked\r\nContentBlock: True\r\nDate: Wed, 31 Oct 2012 16:41:35 GMT\r\nContent-Type: image/gif\r\nConnection: close\r\nContent-Length: 49\r\n\r\n");
                byte[] arrBody = { 0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x01, 0x00, 0x01, 0x00, 0x91, 0xFF, 0x00, 
                                   0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0xC0, 0xC0, 0xC0, 0x00, 0x00, 0x00, 0x21,
                                   0xF9, 0x04, 0x01, 0x00, 0x00, 0x02, 0x00, 0x2c, 0x00, 0x00, 0x00, 0x00, 0x01,
                                   0x00, 0x01, 0x00, 0x00, 0x02, 0x02, 0x54, 0x01, 0x00, 0x3B
                                 };

                FileStream oFS = File.Create(CONFIG.GetPath("Responses") + "1pxtrans.dat");
                oFS.Write(arrHeaders, 0, arrHeaders.Length);
                oFS.Write(arrBody, 0, arrBody.Length);
                oFS.Close();
            }
            catch (Exception eX)
            {
                MessageBox.Show(eX.ToString(), "Failed to create transparent gif...");
            }
        }
    }

    private void miEditBlockedHosts_Click(object sender, System.EventArgs e)
    {
        string sNewList = frmPrompt.GetUserString("Edit Blocked Host List", 
                                                  "Enter semicolon-delimited block list.", hlBlockedHosts.ToString(), true);
        if (null == sNewList)
        {
            FiddlerApplication.UI.sbpInfo.Text = "Block list left unchanged.";
            return;
        }
        else
        {
            string sErrors;
            if (!hlBlockedHosts.AssignFromString(sNewList, out sErrors))
            {
                MessageBox.Show(sErrors, "Error in list");
            }
            else
            {
              FiddlerApplication.UI.sbpInfo.Text = "Block list updated.";
            }
        }
    }

    /// <summary>
    /// The logic for unchecking dependent options in this menu system isn't quite right, but it's fine for now.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void miBlockRule_Click(object sender, System.EventArgs e)
    {
        MenuItem oSender = (sender as MenuItem);
        oSender.Checked = !oSender.Checked;

        bBlockerEnabled = miContentBlockEnabled.Checked;
        if (bBlockerEnabled)
        {
            mnuContentBlock.Text = "&ContentBlock-ON";
            EnsureTransGif();
        }
        else
        {
            mnuContentBlock.Text = "&ContentBlock";
        }

        // Enable menuitems based on overall enabled state.
        miEditBlockedHosts.Enabled = miFlashAlwaysBlock.Enabled = miShortCircuitRedirects.Enabled = miLikelyPaths.Enabled = miHideBlockedSessions.Enabled =
        miBlockXDomainFlash.Enabled = miSplit2.Enabled = bBlockerEnabled;
    }

    public ContentBlocker()
    {
        hlBlockedHosts = new HostList();

        string sList = FiddlerApplication.Prefs.GetStringPref("ext.ContentBlocker.BlockHosts", null);
        if (!String.IsNullOrEmpty(sList))
        {
            hlBlockedHosts.AssignFromString(sList);
        }

        InitializeMenu();
        miShortCircuitRedirects.Checked = FiddlerApplication.Prefs.GetBoolPref("ext.ContentBlocker.ShortcircuitRedirects", false);
        miBlockXDomainFlash.Checked = FiddlerApplication.Prefs.GetBoolPref("ext.ContentBlocker.FlashBlockXDomain", true);
        miFlashAlwaysBlock.Checked = FiddlerApplication.Prefs.GetBoolPref("ext.ContentBlocker.FlashBlockAlways", false);
        miLikelyPaths.Checked = FiddlerApplication.Prefs.GetBoolPref("ext.ContentBlocker.BlockPathsByHeuristic", true);
        miHideBlockedSessions.Checked = FiddlerApplication.Prefs.GetBoolPref("ext.ContentBlocker.HideBlocked", false);
    }
    
    public void OnLoad() 
    {
        /*
         * NB: You might not get called here until ~after~ one of the IAutoTamper methods was called.
         * This is okay for us, because we created our mnuContentBlock in the constructor and its simply not
         * visible anywhere until this method is called and we merge it onto the Fiddler Main menu.
         */
        FiddlerApplication.UI.mnuMain.MenuItems.Add(mnuContentBlock);
        FiddlerApplication.UI.mnuSessionContext.MenuItems.Add(0, miBlockAHost);
    }

    public void OnBeforeUnload()
    {
        // Because we're caching all setting values locally rather than immediately storing them back to Preferences,
        // we now need to serialize those setting values back into the Preferences system.
        //
        // If we always simply wrote/queried the preferences directly, we wouldn't need this step or the corresponding
        // deserialization when our extension starts up. The downside is that there's a slight performance overhead in
        // querying the Preferences system's Dictionary (including its internal locking used for thread-safety).
        //
        FiddlerApplication.Prefs.SetStringPref("ext.ContentBlocker.BlockHosts", hlBlockedHosts.ToString());
        FiddlerApplication.Prefs.SetBoolPref("ext.ContentBlocker.ShortcircuitRedirects", miShortCircuitRedirects.Checked);
        FiddlerApplication.Prefs.SetBoolPref("ext.ContentBlocker.FlashBlockXDomain", miBlockXDomainFlash.Checked);
        FiddlerApplication.Prefs.SetBoolPref("ext.ContentBlocker.FlashBlockAlways", miFlashAlwaysBlock.Checked);
        FiddlerApplication.Prefs.SetBoolPref("ext.ContentBlocker.BlockPathsByHeuristic", miLikelyPaths.Checked);
        FiddlerApplication.Prefs.SetBoolPref("ext.ContentBlocker.HideBlocked", miHideBlockedSessions.Checked);
    }

    /// <summary>
    /// IHandleExecAction handler.
    /// Respond to user input from QuickExec box under the Web Sessions list...
    /// </summary>
    /// <param name="sCommand">The Command String</param>
    /// <returns>TRUE if our extension has handled the command.</returns>
    public bool OnExecAction(string sCommand)
    {
        // TODO: Add "BLOCKSITE" and "UNBLOCKSITE" commands
        if (String.Equals(sCommand, "blocklist", StringComparison.OrdinalIgnoreCase))
        {
            MessageBox.Show(hlBlockedHosts.ToString(), "Block List...");
            return true;
        }
        return false; 
    }

    private void StrikeOrHideSession(Session oSession)
    {
        if (miHideBlockedSessions.Checked) 
        { 
            oSession["ui-hide"] = "userblocked"; 
        }
        else
        {
            oSession["ui-strikeout"] = "userblocked";
            oSession["ui-color"] = "gray";
        }
    }

    /// <summary>
    /// This function kills known matches early
    /// </summary>
    /// <param name="oSession"></param>
    public void AutoTamperRequestBefore(Session oSession) 
    {
        // Return immediately if Content Blocking is disabled
        if (!bBlockerEnabled) return;

        #region ContentBlocking

        #region CheckForHOSTRuleMatches
        string sHost = oSession.host.ToLower();

        if (
            // First check whether hostname starts with ad or ads:
            (sHost.StartsWith("ad.") || sHost.StartsWith("ads.") 
            // Then check the list of blocked hosts:
            || hlBlockedHosts.ContainsHost(sHost)))
        {
            // Set the ReplyWithFile Session flag so that Fiddler will return the specified
            // 1x1 GIF response rather than hitting the server
            oSession["x-replywithfile"] = "1pxtrans.dat";

            StrikeOrHideSession(oSession);
            return;
        }
        #endregion CheckForHOSTRuleMatches

        #region CheckForPathRuleMatches
        if (miLikelyPaths.Checked)
        {
            if (oSession.uriContains("/ad/") || oSession.uriContains("/ads/") || oSession.uriContains("/advert"))
            {
                // We check to see whether the URI also contains a "secret" value that only Fiddler knows. 
                // If it doesn't, we block the content with a fake HTML page with a link that allows unblocking
                // by re-requesting the same URL with the secret appended.
                if (!oSession.uriContains(sSecret))
                {
                    oSession.oRequest.FailSession(404, "Fiddler - ContentBlock", 
                                String.Format("Blocked <a href='{0}?&{1}'>Click to see</a>", oSession.fullUrl, sSecret));

                    // We're changing the SessionState to Done because otherwise it's set to Aborted and we didn't "Abort" per-se.
                    oSession.state = SessionStates.Done;
                    StrikeOrHideSession(oSession);
                    return;
                }
            }
        }
        #endregion CheckForPathRuleMatches

        #region FlashBlockRules
        // If Always Blocking Flash, do it and return immediately
        if (miFlashAlwaysBlock.Checked)
        {
            if (/*oSession.url.EndsWith(".swf") ||*/ oSession.oRequest.headers.Exists("x-flash-version"))
            {
                oSession.oRequest.FailSession(404, "Fiddler - ContentBlock", "Blocked Flash");
                oSession.state = SessionStates.Done;
                StrikeOrHideSession(oSession);
                return;
            }
        }
        else if (miBlockXDomainFlash.Checked)
        {
            // Issue: We don't want to block a .SWF's x-domain request for data, but we do want to
            // block the .SWF itself if it's xDomain.  Hrm.
            if (oSession.uriContains(".swf"))// || oSession.oRequest.headers.Exists("x-flash-version"))
            {
                bool bBlock = false;
                string sReferer = oSession.oRequest["Referer"];

                // Allow if referer was not sent.  Note, this is a hole.
                if (sReferer == String.Empty) return;

                // Block if Referer was from another domain
                if (!bBlock)
                {
                    Uri sFromURI;
                    Uri sToURI;
                    if ((Uri.TryCreate(sReferer, UriKind.Absolute, out sFromURI)) && (Uri.TryCreate(oSession.fullUrl, UriKind.Absolute, out sToURI)))
                    {
                        bBlock = (0 != Uri.Compare(sFromURI, sToURI, UriComponents.Host, UriFormat.Unescaped, StringComparison.InvariantCultureIgnoreCase));
                    }
                }

                if (bBlock)
                {
                    oSession.oRequest.FailSession(404, "Fiddler - ContentBlock", "Blocked Flash");
                    oSession.state = SessionStates.Done;
                    StrikeOrHideSession(oSession);
                }
                return;
            }
        }
        #endregion FlashBlockRules

        #endregion ContentBlocking

        #region ShortCircuitRedirects
        if (miShortCircuitRedirects.Checked && !oSession.HTTPMethodIs("CONNECT"))
        {
            // We URLDecode the target URL that we find if and only if the protocol's :// was encoded.
            bool bNeedDecode = false;

            #region LookForTargetURLInURI
            int ixSubURI = oSession.PathAndQuery.IndexOf("http:", StringComparison.OrdinalIgnoreCase);
            if (ixSubURI < 0)
            {
                ixSubURI = oSession.PathAndQuery.IndexOf("http%3A%2F%2F", StringComparison.OrdinalIgnoreCase);
                bNeedDecode = true;
            }
            if (ixSubURI < 0) ixSubURI = oSession.PathAndQuery.IndexOf("https:", StringComparison.OrdinalIgnoreCase);
            if (ixSubURI < 0)
            {
                ixSubURI = oSession.PathAndQuery.IndexOf("https%3A%2F%2F", StringComparison.OrdinalIgnoreCase);
                bNeedDecode = true;
            }
            #endregion LookForTargetURLInURI

            if (ixSubURI > 0)
            {
                // It looks like the URL contains an embedded URL target; often this is used for tracking purposes.
                // We will skip sending the request to the original server and instead return a redirect pointed 
                // directly at the target server. The client will then contact that host directly.
                oSession.utilCreateResponseAndBypassServer();
                oSession.oResponse.headers.SetStatus(307, "Short-Circuited Redirect");
                string sTarget = oSession.PathAndQuery.Substring(ixSubURI);
                if (bNeedDecode) sTarget = Utilities.UrlDecode(sTarget, Encoding.UTF8);
                oSession.oResponse.headers["OriginalURI"] = oSession.fullUrl;
                oSession.oResponse.headers["Date"] = DateTime.Now.ToString("R");
                oSession.oResponse.headers["Location"] = sTarget;
                StrikeOrHideSession(oSession);
            }
        }
        #endregion ShortCircuitRedirects
    }

    public void AutoTamperResponseAfter(Session oSession)
    {
        if (!bBlockerEnabled) return;

        if (miFlashAlwaysBlock.Checked &&
            oSession.oResponse.headers.ExistsAndContains("Content-Type", "application/x-shockwave-flash"))
        {
            oSession.responseCode = 404;
            oSession.utilSetResponseBody("Fiddler.ContentBlocked");
        }
    }

    public void AutoTamperRequestAfter(Session oSession){ /*noop*/ }
    public void AutoTamperResponseBefore(Session oSession) {/*noop*/}
    public void OnBeforeReturningError(Session oSession) {/*noop*/}
    public void OnAfterSessionComplete(Session oSession) { /*noop*/ }

    // Change class to implement IAutoTamper to IAutoTamper2 to add this callback
    // public void OnPeekAtResponseHeaders(Session oSession) { /*noop*/ }

    // Change class to implement IAutoTamper to IAutoTamper3 to add this callback
    // public void OnPeekAtResponseHeaders(Session oSession) { /*noop*/ }
}
