import { Controller } from "@hotwired/stimulus"

// List of common disposable domains (can be extended)
const DISPOSABLE_DOMAINS = [
  // Popular disposable services
  'mailinator.com', 'yopmail.com', 'guerrillamail.com', '10minutemail.com',
  'trashmail.com', 'throwawaymail.com', 'fakeinbox.com', 'tempmail.com',
  'sharklasers.com', 'getnada.com', 'maildrop.cc', 'dispostable.com',
  'mailcatch.com', 'temp-mail.org', 'tempmailaddress.com', 'tmpmail.org',
  'dropmail.me', 'mailnesia.com', 'spamgourmet.com', 'tempomail.fr',
  'mailmetrash.com', 'trashmail.net', 'dodgit.com', 'jetable.org',
  
  // More disposable services
  'armyspy.com', 'cuvox.de', 'dayrep.com', 'einrot.com', 'fleckens.hu',
  'gustr.com', 'jourrapide.com', 'rhyta.com', 'superrito.com', 'teleworm.us',
  'emailondeck.com', 'getairmail.com', 'mytemp.email', 'tempail.com',
  '33mail.com', 'anonaddy.com', 'burnermail.io', 'discard.email',
  'fakemailgenerator.com', 'notsharingmy.info',
  'owleyes.ch', 'politikerclub.de', 'safetymail.info', 'secure-mail.biz',
  'spam4.me', 'spammotel.com', 'spamspot.com',
  'tempinbox.com', 'temporary-mail.net', 'thankyou2010.com',
  'thisisnotmyrealemail.com', 'tmail.ws', 'trash2009.com', 'wh4f.org',
  'whatpaas.com', 'yep.it', 'zoaxe.com', 'zoemail.com',
  
  // Temporary inbox services
  'inboxalias.com', 'mail-box.cf', 'mail-box.ga', 'mail-box.gq', 'mail-box.ml',
  'mail-box.tk', 'mailbucket.org', 'mailinator.net', 'mailinator.org',
  'mailinator2.com', 'mailinator.co', 'mailinator.xyz', 'mailinator.us',
  'mailinator.info', 'mailinator.pl', 'mailinator.fr', 'mailinator.de',
  'mailinator.ru', 'mailinator.club', 'mailinator.site', 'mailinator.website',
  
  // Yopmail variants
  'yopmail.fr', 'yopmail.net', 'yopmail.org', 'cool.fr.nf', 'jetable.fr.nf',
  'nospam.ze.tc', 'nomail.xl.cx', 'mega.zik.dj', 'speed.1s.fr', 'courriel.fr.nf',
  'moncourrier.fr.nf', 'monemail.fr.nf', 'monmail.fr.nf', 'hide.biz.st',
  
  // GuerrillaMail variants
  'guerrillamail.net', 'guerrillamail.org', 'guerrillamail.biz',
  'guerrillamail.de', 'guerrillamail.co', 'guerrillamail.info',
  'guerrillamail.io', 'guerrillamail.xyz', 'guerrillamail.name',
  'grr.la', 'pokemail.net', 'sharklasers.com',
  
  // Temp-mail variants
  'temp-mail.ru', 'temp-mail.org', 'temp-mail.net', 'temp-mail.com',
  'temp-mail.de', 'temp-mail.fr', 'temp-mail.es', 'temp-mail.it',
  'temp-mail.pl', 'temp-mail.co', 'temp-mail.mx', 'temp-mail.cn',
  'temp-mail.io', 'temp-mail.xyz', 'temp-mail.site', 'temp-mail.online',
  
  // 10MinuteMail variants
  '10minutemail.com', '10minutemail.de', '10minutemail.es',
  '10minutemail.fr', '10minutemail.it', '10minutemail.net',
  '10minutemail.org', '10minutemail.pl', '10minutemail.ru',
  '10minutemail.co.uk', '10minutemail.info', '10minutemail.us',
  
  // More domains
  '0-mail.com', '0815.ru', '0wnd.net', '0wnd.org', '10mail.org',
  '20mail.it', '20minutemail.com', '2prong.com', '30minutemail.com',
  '3d-painting.com', '4warding.com', '4warding.net', '4warding.org',
  '60minutemail.com', '675hosting.com', '675hosting.net', '675hosting.org',
  '6url.com', '75hosting.com', '75hosting.net', '75hosting.org',
  '7tags.com', '9ox.net', 'a-bc.net', 'agedmail.com', 'ama-trade.de',
  'amilegit.com', 'anonbox.net', 'anonymbox.com', 'antichef.com',
  'antichef.net', 'antireg.ru', 'antispam.de', 'antispammail.de',
  'beefmilk.com', 'binkmail.com', 'bio-muesli.net', 'bobmail.info',
  'bodhi.lawlita.com', 'bofthew.com', 'bootybay.de', 'boun.cr',
  'bouncr.com', 'breakthru.com', 'brefmail.com', 'broadbandninja.com',
  'bsnow.net', 'bugmenot.com', 'bumpymail.com', 'casualdx.com',
  'cek.pm', 'centermail.com', 'centermail.net', 'chammy.info',
  'childsavetrust.org', 'chogmail.com', 'choicemail1.com',
  'clixser.com', 'cmail.net', 'cmail.org', 'coldemail.info',
  'cool.fr.nf', 'correo.blogos.net', 'courrieltemporaire.com',
  'crapmail.org', 'cuvox.de', 'd3p.dk', 'dacoolest.com', 'dandikmail.com',
  'dayrep.com', 'deadaddress.com', 'deadspam.com', 'delikkt.de',
  'despam.it', 'despammed.com', 'devnullmail.com', 'dfgh.net',
  'digitalsanctuary.com', 'dingbone.com', 'discardmail.com',
  'discardmail.de', 'disposableaddress.com', 'disposableemailaddresses.com',
  'disposableinbox.com', 'dispose.it', 'disposemail.com',
  'dispostable.com', 'dm.w3internet.co.uk', 'dodgeit.com',
  'dodgit.org', 'donemail.ru', 'dontreg.com', 'dontsendmespam.de',
  'dump-email.info', 'dumpandjunk.com', 'dumpyemail.com',
  'e4ward.com', 'easytrashmail.com', 'einmalmail.de', 'einrot.com',
  'eintagsmail.de', 'email60.com', 'emaildienst.de', 'emailgo.de',
  'emailias.com', 'emaillime.com', 'emailmiser.com', 'emailproxsy.com',
  'emailsensei.com', 'emailtemporanea.net', 'emailtemporario.com.br',
  'emailthe.net', 'emailtmp.com', 'emailwarden.com', 'emailx.at.hm',
  'emailxfer.com', 'emeil.in', 'emeil.ir', 'emz.net', 'explodemail.com',
  'fake-mail.com', 'fakemail.fr', 'fakemailgenerator.com',
  'fastacura.com', 'fastchevy.com', 'fastchrysler.com', 'fastkawasaki.com',
  'fastmazda.com', 'fastmitsubishi.com', 'fastnissan.com', 'fastsubaru.com',
  'fastsuzuki.com', 'fasttoyota.com', 'fastyamaha.com', 'figjs.com',
  'filzmail.com', 'fizmail.com', 'fleckens.hu', 'frapmail.com',
  'friendlymail.co.uk', 'front14.org', 'fuckingduh.com', 'fudgerub.com',
  'fyii.de', 'garliclife.com', 'gehensiemirnichtaufdensack.de',
  'get1mail.com', 'get2mail.fr', 'getairmail.com', 'getonemail.com',
  'giantmail.de', 'girlsundertheinfluence.com', 'gishpuppy.com',
  'gmial.com', 'goemailgo.com', 'gotmail.net', 'gotmail.org',
  'gotti.otherinbox.com', 'great-host.in', 'greensloth.com',
  'gsrv.co.uk', 'guerillamail.biz', 'guerillamail.com', 'guerillamail.de',
  'guerillamail.info', 'guerillamail.net', 'guerillamail.org',
  'guerrillamail.co', 'guerrillamail.info', 'guerrillamail.io',
  'guerrillamail.name', 'guerrillamail.xyz', 'gustr.com', 'harakirimail.com',
  'hat-geld.de', 'hatespam.org', 'herp.in', 'hidemail.de', 'hidzz.com',
  'hmamail.com', 'hopemail.biz', 'ieh-mail.de', 'ikbenspamvrij.nl',
  'imails.info', 'inbax.tk', 'inbox.si', 'inboxalias.com', 'inboxclean.com',
  'inboxclean.org', 'infocom.zp.ua', 'instant-mail.de', 'ip6.li',
  'irish2me.com', 'iwi.net', 'jetable.com', 'jetable.fr.nf',
  'jetable.net', 'jetable.org', 'jnxjn.com', 'jourrapide.com',
  'jsrsolutions.com', 'kasmail.com', 'kaspop.com', 'keepmymail.com',
  'killmail.com', 'killmail.net', 'klassmaster.com', 'klassmaster.net',
  'klzlk.com', 'koszmail.pl', 'kulturbetrieb.info', 'kurzepost.de',
  'lawlita.com', 'letthemeatspam.com', 'lhsdv.com', 'lifebyfood.com',
  'link2mail.net', 'litedrop.com', 'lol.ovpn.to', 'lookugly.com',
  'lopl.co.cc', 'lortemail.dk', 'lr78.com', 'lroid.com', 'lukop.dk',
  'm21.cc', 'mail-filter.com', 'mail-temporaire.fr', 'mail.by',
  'mail.mezimages.net', 'mail114.net', 'mail2rss.org', 'mail333.com',
  'mail4trash.com', 'mailbidon.com', 'mailbiz.biz', 'mailblocks.com',
  'mailbucket.org', 'mailcat.biz', 'mailcatch.com', 'mailde.de',
  'mailde.info', 'maildrop.cc', 'maildu.de', 'maildx.com',
  'maileater.com', 'mailexpire.com', 'mailfa.tk', 'mailfly.com',
  'mailforspam.com', 'mailfreeonline.com', 'mailguard.me',
  'mailimate.com', 'mailin8r.com', 'mailinatar.com', 'mailinater.com',
  'mailinator.co.uk', 'mailinator.gq', 'mailinator.info', 'mailinator.me',
  'mailinator.name', 'mailinator.net', 'mailinator.org', 'mailinator.pl',
  'mailinator.us', 'mailinator.xyz', 'mailinator2.com', 'mailincubator.com',
  'mailismagic.com', 'mailme.lv', 'mailme24.com', 'mailmoat.com',
  'mailms.com', 'mailnator.com', 'mailnull.com', 'mailorg.org',
  'mailpick.biz', 'mailrock.biz', 'mailscrap.com', 'mailshell.com',
  'mailsiphon.com', 'mailtemp.info', 'mailtemporaire.com',
  'mailtemporaire.fr', 'mailtothis.com', 'mailtrash.net', 'mailtv.net',
  'mailtv.tv', 'mailzilla.com', 'makemetheking.com', 'manybrain.com',
  'mbx.cc', 'mega.zik.dj', 'meinspamschutz.de', 'meltmail.com',
  'messagebeamer.de', 'mierdamail.com', 'migumail.com',
  'ministry-of-silly-walks.de', 'mintemail.com', 'misterpinball.de',
  'moncourrier.fr.nf', 'monemail.fr.nf', 'monmail.fr.nf', 'monumentmail.com',
  'mt2009.com', 'mt2014.com', 'mycard.net.ua', 'mycleaninbox.net',
  'mymail-in.net', 'mypacks.net', 'mypartyclip.de', 'myphantomemail.com',
  'mysamp.de', 'mytemp.email', 'mytempemail.com', 'mytrashmail.com',
  'nabuma.com', 'neomailbox.com', 'nepwk.com', 'nervmich.net',
  'nervtmich.net', 'netmails.com', 'netmails.net', 'neverbox.com',
  'nice-4u.com', 'nincsmail.com', 'nincsmail.hu', 'nnh.com', 'no-spam.ws',
  'nobulk.com', 'noclickemail.com', 'nogmailspam.info', 'nomail2me.com',
  'nomorespamemails.com', 'nospam.ze.tc', 'nospam4.us', 'nospamfor.us',
  'nospammail.net', 'notmailinator.com', 'notsharingmy.info',
  'nowhere.org', 'nowmymail.com', 'nurfuerspam.de', 'objectmail.com',
  'obobbo.com', 'odaymail.com', 'odnorazovoe.ru', 'one-time.email',
  'oneoffemail.com', 'oneoffmail.com', 'onlatedotcom.info',
  'online.ms', 'oopi.org', 'opayq.com', 'ordinaryamerican.net',
  'otherinbox.com', 'ourklips.com', 'outlawspam.com', 'ovpn.to',
  'owlpic.com', 'pancakemail.com', 'pcusers.otherinbox.com',
  'pepbot.com', 'pfui.ru', 'pimpedupmyspace.com', 'pjjkp.com',
  'plexolan.de', 'poczta.onet.pl', 'politikerclub.de', 'poofy.org',
  'pookmail.com', 'privacy.net', 'privatdemail.net', 'proxymail.eu',
  'prtnx.com', 'putthisinyourspamdatabase.com', 'quickinbox.com',
  'quickmail.nl', 'rcpt.at', 'reallymymail.com', 'realtyalerts.ca',
  'recode.me', 'recursor.net', 'regbypass.com', 'rejectmail.com',
  'rhyta.com', 'rmqkr.net', 'royal.net', 'rtrtr.com',
  's0ny.net', 'safe-mail.net', 'safersignup.de', 'safetymail.info',
  'samsclass.info', 'sandelf.de', 'saynotospams.com', 'schafmail.de',
  'schrott-email.de', 'secretemail.de', 'secure-mail.biz',
  'selfdestructingmail.com', 'sendspamhere.com', 'services391.com',
  'sharklasers.com', 'shieldemail.com', 'shiftmail.com', 'shitmail.me',
  'shitware.nl', 'shmeriously.com', 'shortmail.net', 'sibmail.com',
  'sinnlos-mail.de', 'slapsfromlastnight.com', 'slaskpost.se',
  'smashmail.de', 'smellfear.com', 'snakemail.com', 'sneakemail.com',
  'sneakmail.de', 'snkmail.com', 'sofimail.com', 'solvemail.info',
  'soodonims.com', 'spam.la', 'spam.su', 'spam4.me', 'spamavert.com',
  'spambob.com', 'spambob.net', 'spambob.org', 'spambog.com',
  'spambog.de', 'spambog.net', 'spambog.ru', 'spambooger.com',
  'spambox.info', 'spambox.irishspringrealty.com', 'spambox.us',
  'spamcannon.com', 'spamcannon.net', 'spamcero.com', 'spamcon.org',
  'spamcorptastic.com', 'spamcowboy.com', 'spamcowboy.net',
  'spamcowboy.org', 'spamday.com', 'spamdecoy.net', 'spamex.com',
  'spamfree24.com', 'spamfree24.de', 'spamfree24.eu', 'spamfree24.info',
  'spamfree24.net', 'spamfree24.org', 'spamgoes.in', 'spamgourmet.com',
  'spamgourmet.net', 'spamgourmet.org', 'spamherelots.com',
  'spamhereplease.com', 'spamhole.com', 'spamify.com', 'spaminator.de',
  'spamkill.info', 'spaml.com', 'spaml.de', 'spammotel.com',
  'spamobox.com', 'spamoff.de', 'spamslicer.com', 'spamspot.com',
  'spamstack.net', 'spamthis.co.uk', 'spamthisplease.com',
  'spamtrail.com', 'speed.1s.fr', 'supergreatmail.com', 'superrito.com',
  'superstachel.de', 'suremail.info', 'talkinator.com', 'teewars.org',
  'teleworm.com', 'teleworm.us', 'temp-mail.biz', 'temp-mail.co',
  'temp-mail.cn', 'temp-mail.de', 'temp-mail.es', 'temp-mail.fr',
  'temp-mail.it', 'temp-mail.mx', 'temp-mail.pl', 'temp-mail.ru',
  'temp-mails.com', 'tempail.com', 'tempalias.com', 'tempe-mail.com',
  'tempemail.co.za', 'tempemail.com', 'tempemail.net', 'tempemail.org',
  'tempemails.io', 'tempinbox.co.uk', 'tempinbox.com', 'tempmail.co',
  'tempmail.de', 'tempmail.eu', 'tempmail.it', 'tempmail.us',
  'tempmail.ws', 'tempmail2.com', 'tempmaildemo.com', 'tempmailer.com',
  'tempmailer.de', 'tempomail.fr', 'temporarily.de', 'temporarioemail.com.br',
  'temporaryemail.net', 'temporaryemailaddress.com', 'temporaryforwarding.com',
  'temporaryinbox.com', 'thanksnospam.info', 'thankyou2010.com',
  'thc.st', 'thelimestones.com', 'thisisnotmyrealemail.com',
  'thismail.net', 'throwawayemailaddress.com', 'tilien.com',
  'tittbit.in', 'tmail.com', 'tmail.ws', 'toiea.com', 'toomail.biz',
  'topranklist.de', 'tradermail.info', 'trash-amil.com', 'trash-mail.at',
  'trash-mail.com', 'trash-mail.de', 'trash-mail.ga', 'trash-mail.gq',
  'trash-mail.ml', 'trash-mail.tk', 'trash2009.com', 'trash2010.com',
  'trash2011.com', 'trashdevil.com', 'trashdevil.de', 'trashemail.de',
  'trashmail.at', 'trashmail.com', 'trashmail.de', 'trashmail.me',
  'trashmail.net', 'trashmail.org', 'trashmail.ws', 'trashmailer.com',
  'trashymail.com', 'trashymail.net', 'trialmail.de', 'trillianpro.com',
  'twinmail.de', 'tyldd.com', 'uggsrock.com', 'umail.net', 'uroid.com',
  'us.af', 'venompen.com', 'veryrealemail.com', 'viditag.com',
  'viralplays.com', 'vkcode.ru', 'vomoto.com', 'vpn.st', 'vsimcard.com',
  'vubby.com', 'wasteland.rfc822.org', 'webemail.me', 'weg-werf-email.de',
  'wegwerf-email-addressen.de', 'wegwerf-email-adressen.de',
  'wegwerf-email.de', 'wegwerf-email.net', 'wegwerf-emails.de',
  'wegwerfadresse.de', 'wegwerfemail.com', 'wegwerfemail.de',
  'wegwerfmail.de', 'wegwerfmail.info', 'wegwerfmail.net',
  'wegwerfmail.org', 'wh4f.org', 'whyspam.me', 'willselfdestruct.com',
  'winemaven.info', 'wronghead.com', 'wuzup.net', 'wuzupmail.net',
  'xagloo.com', 'xemaps.com', 'xents.com', 'xmaily.com', 'xoxy.net',
  'yep.it', 'yogamaven.com', 'yopmail.com', 'yopmail.fr', 'yopmail.gq',
  'yopmail.net', 'yopmail.org', 'youmailr.com', 'yourdomain.com',
  'ypmail.webarnak.fr.eu.org', 'yuurok.com', 'z1p.biz', 'za.com',
  'zehnminuten.de', 'zehnminutenmail.de', 'zetmail.com', 'zippymail.info',
  'zoaxe.com', 'zoemail.com', 'zoemail.net', 'zomg.info'
];

export default class extends Controller {
  static targets = ["email", "message"]

  checkEmail(event) {
  const email = event.target.value;
  const messageElement = document.getElementById('email-validation-message');
  
  if (!email) {
    this.hideMessage();
    return;
  }

  // Check email format
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    this.showMessage("Please enter a valid email address", "error");
    return;
  }

  // Check for disposable domain
  const domain = email.toLowerCase().split('@')[1];
  
  // Check for exact match or subdomain match
  const isDisposable = DISPOSABLE_DOMAINS.some(disposableDomain => {
    return domain === disposableDomain || 
           domain.endsWith('.' + disposableDomain);
  });
  
  if (isDisposable) {
    this.showMessage("Temporary/disposable emails are not allowed. Please use a permanent email.", "error");
  } else {
    this.hideMessage();
  }
}

  showMessage(text, type) {
    const messageElement = document.getElementById('email-validation-message');
    messageElement.textContent = text;
    messageElement.className = `mt-1 text-sm ${type === 'error' ? 'text-red-600' : 'text-green-600'}`;
    messageElement.classList.remove('hidden');
  }

  hideMessage() {
    const messageElement = document.getElementById('email-validation-message');
    messageElement.classList.add('hidden');
  }
}