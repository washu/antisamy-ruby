require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module AntiSamy
  describe AntiSamy do
    let(:policy_file) {"#{File.join(File.dirname(__FILE__), '..', 'policy-examples')}/antisamy-testing.xml"}
    let(:strict_policy) {"#{File.join(File.dirname(__FILE__), '..', 'policy-examples')}/antisamy-anythinggoes.xml"}
    let(:policy_object) {AntiSamy.policy(policy_file)}

    it "should load a policy" do
      p = AntiSamy.policy(policy_file)
      p.should_not == nil
    end
    
    it "should wrap plain text" do
      input = "Hi"
      p = AntiSamy.policy(policy_file)
      r = AntiSamy.scan(input,p)
      r.clean_html.should == "<p>#{input}</p>"
    end
    
    it "should scan our sample html and change nothing" do
      input = "<p>Hi</p>"
      p = AntiSamy.policy(policy_file)
      r = AntiSamy.scan(input,p)
      r.clean_html.should == input
    end

    it "should tak our input and remove the script tags" do
      input = "<p style='font-size: 16px'>Hi</p><script> some junk</script>"
      expec = "<p>Hi</p>"
      p = AntiSamy.policy(policy_file)
      r = AntiSamy.scan(input,p)
      r.clean_html.should == expec
      r.messages.size.should == 2 # error 1 for script tag, error 2 for style tag
    end
    
    # Script attacks
    {
      "test<script>alert(document.cookie)</script>" => "script",
      "<<<><<script src=http://fake-evil.ru/test.js>" => "<script",
      "<script<script src=http://fake-evil.ru/test.js>>" => "<script",
      "<SCRIPT/XSS SRC=\"http://ha.ckers.org/xss.js\"></SCRIPT>" => "<script",
      '<BODY onload!#$%&()*~+-_.,:;?@[/|\\]^`=alert(\"XSS\")>' => "onload",
      "<BODY ONLOAD=alert('XSS')>" => "alert",
      "<iframe src=http://ha.ckers.org/scriptlet.html <" => "<iframe",
      "<INPUT TYPE=\"IMAGE\" SRC=\"javascript:alert('XSS');\">" => "src"
    }.each_pair do |k,v|
      it "should remove #{v} from #{k} for script attacks" do
        r = AntiSamy.scan(k,policy_object)
        r.clean_html.should_not include(v)
      end
    end
    
    #Image Attacks
    {
      "<img src='http://www.myspace.com/img.gif'>"=>"<img",
      "<img src=javascript:alert(document.cookie)>"=>"<img",
      "<IMG SRC=&#106;&#97;&#118;&#97;&#115;&#99;&#114;&#105;&#112;&#116;&#58;&#97;&#108;&#101;&#114;&#116;&#40;&#39;&#88;&#83;&#83;&#39;&#41;>"=>"<img",
      "<IMG SRC=&#0000106&#0000097&#0000118&#0000097&#0000115&#0000099&#0000114&#0000105&#0000112&#0000116&#0000058&#0000097&#0000108&#0000101&#0000114&#0000116&#0000040&#0000039&#0000088&#0000083&#0000083&#0000039&#0000041>" => "&amp;",
      "<IMG SRC=&#x6A&#x61&#x76&#x61&#x73&#x63&#x72&#x69&#x70&#x74&#x3A&#x61&#x6C&#x65&#x72&#x74&#x28&#x27&#x58&#x53&#x53&#x27&#x29>"=>"&amp;",
      "<IMG SRC=\"jav&#x0D;ascript:alert('XSS');\">" => "alert",
      "<IMG SRC=\"javascript:alert('XSS')\"" => "javascript",
      "<IMG LOWSRC=\"javascript:alert('XSS')\">"=>"javascript",
      "<BGSOUND SRC=\"javascript:alert('XSS');\">"=>"javascript",      
    }.each_pair do |k,v|
      it "should remove #{v} from #{k} for image attacks" do
        r = AntiSamy.scan(k,policy_object)
        r.clean_html.should_not include(v)
      end
    end
    
    # Css attacks
    {
      "<div style=\"position:absolute\">" => "position",
      "<style>b { position:absolute }</style>" => "position",
      "<div style=\"z-index:25\">" => "z-index",
      "<style>z-index:25</style>" => "z-index",
      "<div style=\"font-family: Geneva, Arial, courier new, sans-serif\">" => "font-family"
    }.each_pair do |k,v|
      it "should remove #{v} from #{k} for CSS attacks" do
        r = AntiSamy.scan(k,policy_object)
        r.clean_html.should_not include(v)
      end
    end
    
    #href attacks
    {
      "<LINK REL=\"stylesheet\" HREF=\"javascript:alert('XSS');\">" => "href",
      "<LINK REL=\"stylesheet\" HREF=\"http://ha.ckers.org/xss.css\">" => "href",
      "<STYLE>@import'http://ha.ckers.org/xss.css';</STYLE>" => "ha.ckers",
      "<STYLE>BODY{-moz-binding:url(\"http://ha.ckers.org/xssmoz.xml#xss\")}</STYLE>" => "ha.ckers",
      "<STYLE>BODY{-moz-binding:url(\"http://ha.ckers.org/xssmoz.xml#xss\")}</STYLE>" => "xss",
      "<STYLE>li {list-style-image: url(\"javascript:alert('XSS')\");}</STYLE><UL><LI>XSS" => "javascript",
      "<IMG SRC='vbscript:msgbox(\"XSS\")'>" => "vbscript",
      "<a . href=\"http://www.test.com\">" => " . ",
      "<a - href=\"http://www.test.com\">" => "-",
      "<META HTTP-EQUIV=\"refresh\" CONTENT=\"0; URL=http://;URL=javascript:alert('XSS');\">" => "meta",
      "<META HTTP-EQUIV=\"refresh\" CONTENT=\"0;url=javascript:alert('XSS');\">" => "meta",
      "<META HTTP-EQUIV=\"refresh\" CONTENT=\"0;url=data:text/html;base64,PHNjcmlwdD5hbGVydCgnWFNTJyk8L3NjcmlwdD4K\">" => "meta",
      "<IFRAME SRC=\"javascript:alert('XSS');\"></IFRAME>" => "iframe",
      "<FRAMESET><FRAME SRC=\"javascript:alert('XSS');\"></FRAMESET>" => "javascript",
      "<TABLE BACKGROUND=\"javascript:alert('XSS')\">" => "background",
      "<TABLE><TD BACKGROUND=\"javascript:alert('XSS')\">" => "background",
      "<DIV STYLE=\"background-image: url(javascript:alert('XSS'))\">" => "javascript",
      "<DIV STYLE=\"width: expression(alert('XSS'));\">" => "alert",
      "<IMG STYLE=\"xss:expr/*XSS*/ession(alert('XSS'))\">" => "alert",
      "<STYLE>@im\\port'\\ja\\vasc\\ript:alert(\"XSS\")';</STYLE>" => "alert",
      "<BASE HREF=\"javascript:alert('XSS');//\">" => "javascript",
      "<BaSe hReF=\"http://arbitrary.com/\">" => "base",
      "<OBJECT TYPE=\"text/x-scriptlet\" DATA=\"http://ha.ckers.org/scriptlet.html\"></OBJECT>" => "object",
      "<OBJECT classid=clsid:ae24fdae-03c6-11d1-8b76-0080c744f389><param name=url value=javascript:alert('XSS')></OBJECT>" => "object",
      "<EMBED SRC=\"http://ha.ckers.org/xss.swf\" AllowScriptAccess=\"always\"></EMBED>" => "embed",
      "<EMBED SRC=\"data:image/svg+xml;base64,PHN2ZyB4bWxuczpzdmc9Imh0dH A6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcv MjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hs aW5rIiB2ZXJzaW9uPSIxLjAiIHg9IjAiIHk9IjAiIHdpZHRoPSIxOTQiIGhlaWdodD0iMjAw IiBpZD0ieHNzIj48c2NyaXB0IHR5cGU9InRleHQvZWNtYXNjcmlwdCI+YWxlcnQoIlh TUyIpOzwvc2NyaXB0Pjwvc3ZnPg==\" type=\"image/svg+xml\" AllowScriptAccess=\"always\"></EMBED>" => "embed",
      "<SCRIPT a=\">\" SRC=\"http://ha.ckers.org/xss.js\"></SCRIPT>" => "script",
      "<SCRIPT a=\">\" '' SRC=\"http://ha.ckers.org/xss.js\"></SCRIPT>" => "script",
      "<SCRIPT a=`>` SRC=\"http://ha.ckers.org/xss.js\"></SCRIPT>" => "script",
      "<SCRIPT a=\">'>\" SRC=\"http://ha.ckers.org/xss.js\"></SCRIPT>" => "script",
      "<SCRIPT>document.write(\"<SCRI\");</SCRIPT>PT SRC=\"http://ha.ckers.org/xss.js\"></SCRIPT>" => "script",
      "<SCRIPT SRC=http://ha.ckers.org/xss.js" => "script",
      "<div/style=&#92&#45&#92&#109&#111&#92&#122&#92&#45&#98&#92&#105&#92&#110&#100&#92&#105&#110&#92&#103:&#92&#117&#114&#108&#40&#47&#47&#98&#117&#115&#105&#110&#101&#115&#115&#92&#105&#92&#110&#102&#111&#46&#99&#111&#46&#117&#107&#92&#47&#108&#97&#98&#115&#92&#47&#120&#98&#108&#92&#47&#120&#98&#108&#92&#46&#120&#109&#108&#92&#35&#120&#115&#115&#41&>" => "style",
      "<a href='aim: &c:\\windows\\system32\\calc.exe' ini='C:\\Documents and Settings\\All Users\\Start Menu\\Programs\\Startup\\pwnd.bat'>" => "calc.exe",
      "<!--\n<A href=\n- --><a href=javascript:alert:document.domain>test-->" => "javascript",
      "<a></a style=\"\"xx:expr/**/ession(document.appendChild(document.createElement('script')).src='http://h4k.in/i.js')\">" => "<a style=",
      "<a onblur=\"alert(secret)\" href=\"http://www.google.com\">Google</a>" => "blur",
      "<b><i>Some Text</b></i>" => "<i />",
      "<div style=\"font-family: Geneva, Arial, courier new, sans-serif\">" => "font-family",
      "<style type=\"text/css\"><![CDATA[P {  margin-bottom: 0.08in; } ]]></style>" => "margin"
      
    }.each_pair do |k,v|
      it "should remove #{v} from #{k} for href attacks" do
        r = AntiSamy.scan(k,policy_object)
        r.clean_html.should_not include(v)
      end
    end
    
    it "shoud import some stylesheets" do
      input = "<style>@import url(http://www.owasp.org/skins/monobook/main.css);@import url(http://www.w3schools.com/stdtheme.css);@import url(http://www.google.com/ig/f/t1wcX5O39cc/ig.css); </style>"
      r = AntiSamy.scan(input,policy_object)
      r.clean_html.should_not be_empty
    end
    
    it "should not touch this url" do
      input = "<a href=\"http://www.aspectsecurity.com\">Aspect Security</a>"
      r = AntiSamy.scan(input,policy_object)
      r.clean_html.should == input      
    end
    
  end
end
