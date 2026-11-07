package it.naif.bocciesoccer

import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CalendarMonth
import androidx.compose.material.icons.filled.LiveTv
import androidx.compose.material.icons.filled.Shield
import androidx.compose.material.icons.filled.SportsSoccer
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp

private val Navy = Color(0xFF101D32)
private val Panel = Color(0xFF1D3049)
private val Mint = Color(0xFF21C58E)
private val Muted = Color(0xFFB9C7D8)

class MainActivity : ComponentActivity() {
    private val protonPackage = "ch.protonvpn.android"
    private val prefs by lazy { getSharedPreferences("boccie_soccer", MODE_PRIVATE) }
    private var didAutoLaunch = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme(colorScheme = darkColorScheme(
                primary = Mint, background = Navy, surface = Panel,
                onPrimary = Navy, onBackground = Color.White, onSurface = Color.White
            )) {
                BoccieSoccerScreen(
                    autoLaunch = prefs.getBoolean("auto_launch_proton", true),
                    onAutoLaunchChange = { prefs.edit().putBoolean("auto_launch_proton", it).apply() },
                    onOpenProton = { openProton() },
                    onOpenUrl = { url -> openUrl(url) }
                )
            }
        }
        // First version: opens Proton VPN on app launch if the user leaves this option enabled.
        // Android/Proton still require the user to tap Connect and approve any system prompt.
        if (!didAutoLaunch && prefs.getBoolean("auto_launch_proton", true)) {
            didAutoLaunch = true
            window.decorView.postDelayed({ openProton(showToast = false) }, 450)
        }
    }

    private fun openProton(showToast: Boolean = true) {
        val launch = packageManager.getLaunchIntentForPackage(protonPackage)
        if (launch != null) {
            launch.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(launch)
        } else {
            openUrl("https://play.google.com/store/apps/details?id=$protonPackage")
            if (showToast) Toast.makeText(this, "Installa Proton VPN per continuare", Toast.LENGTH_LONG).show()
        }
    }

    private fun openUrl(url: String) {
        try {
            startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
        } catch (_: ActivityNotFoundException) {
            Toast.makeText(this, "Nessuna app disponibile per aprire il collegamento", Toast.LENGTH_LONG).show()
        }
    }
}

@Composable
private fun BoccieSoccerScreen(
    autoLaunch: Boolean,
    onAutoLaunchChange: (Boolean) -> Unit,
    onOpenProton: () -> Unit,
    onOpenUrl: (String) -> Unit
) {
    var selectedTab by remember { mutableIntStateOf(0) }
    Surface(modifier = Modifier.fillMaxSize(), color = Navy) {
        Column(modifier = Modifier.verticalScroll(rememberScrollState()).padding(20.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.SpaceBetween, modifier = Modifier.fillMaxWidth()) {
                Column {
                    Text("BOCCIE SOCCER", color = Color.White, style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Black)
                    Text("SERIE A • LIVE", color = Mint, style = MaterialTheme.typography.labelLarge, fontWeight = FontWeight.Bold)
                }
                Icon(Icons.Default.SportsSoccer, contentDescription = null, tint = Mint, modifier = Modifier.size(38.dp))
            }
            Spacer(Modifier.height(22.dp))
            Text("Il calcio italiano, in un unico posto.", color = Color.White, style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
            Text("Calendario, programmazione e collegamenti ufficiali.", color = Muted, style = MaterialTheme.typography.bodyMedium)
            Spacer(Modifier.height(20.dp))

            SectionCard(title = "PROTON VPN", icon = { Icon(Icons.Default.Shield, null, tint = Mint) }) {
                Text("Piano rilevato: Proton VPN Free (impostato dall'utente).", color = Muted, style = MaterialTheme.typography.bodySmall)
                Spacer(Modifier.height(8.dp))
                Text("Il piano gratuito sceglie automaticamente il server: non possiamo forzare la Romania né confermare la posizione da questa app.", color = Muted, style = MaterialTheme.typography.bodySmall)
                Spacer(Modifier.height(10.dp))
                Button(onClick = onOpenProton, modifier = Modifier.fillMaxWidth()) { Text("Apri Proton VPN") }
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text("Apri Proton all'avvio", color = Color.White, modifier = Modifier.weight(1f))
                    Switch(checked = autoLaunch, onCheckedChange = onAutoLaunchChange)
                }
                Text("L'app apre Proton, ma per collegarti devi premere Connect in Proton e confermare le richieste Android.", color = Muted, style = MaterialTheme.typography.labelSmall)
            }

            Spacer(Modifier.height(14.dp))
            SectionCard(title = "BOCCIE SOCCER", icon = { Icon(Icons.Default.CalendarMonth, null, tint = Mint) }) {
                Text("Consulta il calendario ufficiale aggiornato della Lega Serie A.", color = Muted, style = MaterialTheme.typography.bodySmall)
                Spacer(Modifier.height(10.dp))
                Button(onClick = { onOpenUrl("https://www.legaseriea.it/it/serie-a/calendario-e-risultati") }, modifier = Modifier.fillMaxWidth()) {
                    Text("Apri calendario e risultati")
                }
            }

            Spacer(Modifier.height(14.dp))
            SectionCard(title = "DIGI SPORT ROMANIA", icon = { Icon(Icons.Default.LiveTv, null, tint = Mint) }) {
                Text("Cerca le partite di Serie A nella programmazione Digi Sport e apri il servizio ufficiale.", color = Muted, style = MaterialTheme.typography.bodySmall)
                Spacer(Modifier.height(10.dp))
                OutlinedButton(onClick = { onOpenUrl("https://www.digisport.ro/program-tv") }, modifier = Modifier.fillMaxWidth()) { Text("Programmazione TV Digi Sport") }
                OutlinedButton(onClick = { onOpenUrl("https://www.digisport.ro/live/online") }, modifier = Modifier.fillMaxWidth()) { Text("Digi Sport Live ufficiale") }
            }

            Spacer(Modifier.height(16.dp))
            Text("Nota sui diritti", color = Color.White, fontWeight = FontWeight.Bold)
            Text("Non hai un abbonamento Digi: i link mostrano solo contenuti e accessi autorizzati. La VPN non sostituisce un abbonamento e non garantisce l'accesso alle dirette. Proton VPN Free non consente di scegliere manualmente la Romania.", color = Muted, style = MaterialTheme.typography.bodySmall)
            Spacer(Modifier.height(24.dp))
            Text("BOCCIE SOCCER • versione 1.2", color = Muted, style = MaterialTheme.typography.labelSmall, modifier = Modifier.align(Alignment.CenterHorizontally))
        }
    }
}

@Composable
private fun SectionCard(title: String, icon: @Composable () -> Unit, content: @Composable ColumnScope.() -> Unit) {
    Card(colors = CardDefaults.cardColors(containerColor = Panel), shape = RoundedCornerShape(18.dp), modifier = Modifier.fillMaxWidth()) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                icon(); Spacer(Modifier.width(8.dp)); Text(title, color = Color.White, fontWeight = FontWeight.Bold)
            }
            Spacer(Modifier.height(12.dp))
            content()
        }
    }
}
